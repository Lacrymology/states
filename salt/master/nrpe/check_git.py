#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.
"""
Nagios plugin to check if gitfs, ext_pillar git repositories of
salt-master contains bad characters.

List of bad characters:

* ``/``
"""

__author__ = 'Diep Pham'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import logging
import subprocess

import nagiosplugin
import salt

from pysc import nrpe

log = logging.getLogger('salt.master.check_git')

BAD_CHARS = ['/']


def _parse_ext_pillar(ext_pillar):
    """
    get the list of repositories from ext_pillar config
    format::

        ext_pillar:
          - git: develop git@github.com:example/example root=sub
          - hiera: /etc/hiera.yaml
    """
    log.debug("ext_pillar config: %s", ext_pillar)
    repos = []
    for pillar in ext_pillar:
        if pillar.get('git', None):
            # repository is second element
            repos.append(pillar['git'].split()[1])
    log.debug("ext_pillar git repositories: %s", repos)
    return repos


def _list_branches(repo):
    """
    return list of git branches
    """
    output = subprocess.check_output(
        ["git", "ls-remote", "--heads", "--tags", repo])

    # example output:
    #
    # 146930e02124dff706b8100008ef410c83c157e1    HEAD
    # d438ce7f06043bc6f62e553414e1ff27c5e93b65    refs/heads/pkgrepo-clean-file
    # 98411034273d69cbb6c5421d0557488b1ef801b2    refs/heads/remove_old_style

    log.debug("Listing branches for repo: %s", repo)
    branches = []
    for line in output.splitlines():
        ref = line.split()[1]
        branches.append(ref.split("/", 2)[2])
    log.debug("List of branches for repo %s: %s", repo, branches)
    return branches


def _branch_filter(repos):
    """
    return list of git repo that contains bad characters
    """
    bad_branches = {}
    for repo in repos:
        branches = _list_branches(repo)
        for branch in branches:
            for char in BAD_CHARS:
                if char in branch:
                    bad_branches.setdefault(repo, branch)
                    log.debug("Bad branch name: %s of repo: %s", branch, repo)

    return bad_branches


class GitBranchesCheck(nagiosplugin.Resource):

    def __init__(self, path='/etc/salt/master'):
        self._path = path
        self._state = nagiosplugin.state.Ok
        self._error = None

    def probe(self):
        log.debug("GitBranchesCheck.probe started")

        # salt won't raise error if config file is not found
        try:
            with open(self._path):
                pass
        except IOError as err:
            log.debug("could not read salt-master config: %s", err)
            self._state = nagiosplugin.state.Critical
            self._error = "could not read salt-master config: {}".format(
                self._path)
            return [nagiosplugin.Metric(
                "git_branch", self._state, context="git_branch")]

        log.debug("salt-master config file: %s", self._path)
        config = salt.config.master_config(self._path)
        log.debug("salt-master config: %s", config)
        repos = []
        repos.extend(config.get('gitfs_remotes', []))
        repos.extend(_parse_ext_pillar(config.get('ext_pillar', [])))
        log.debug("list of git repositories to check: %s", repos)

        bad_branches = _branch_filter(repos)
        log.debug("bad branch names: %s", bad_branches)

        if bad_branches:
            log.debug("found branch name with bad character")
            self._error = "bad branches: {0}".format(bad_branches)
            self._state = nagiosplugin.state.Critical

        log.debug("GitBranchesCheck.probe finished")

        return [nagiosplugin.Metric(
            "git_branch", self._state, context="git_branch")]


class GitBranchesContext(nagiosplugin.Context):

    def evaluate(self, metric, resource):
        if metric.value == nagiosplugin.state.Ok:
            result = self.result_cls(
                nagiosplugin.state.Ok,
                hint="no git branch name with bad characters found.",
                metric=metric)
        else:
            result = self.result_cls(
                nagiosplugin.state.Critical,
                hint=resource._error,
                metric=metric)
        return result


def check_git(config):
    return(
        GitBranchesCheck(path=config["path"]),
        GitBranchesContext("git_branch"),
    )

if __name__ == '__main__':
    nrpe.check(check_git, {
        "path": "/etc/salt/master",
    })
