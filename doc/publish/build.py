#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Usage of this is governed by a license that can be found in doc/license.rst

__author__ = 'Diep Pham'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import logging
import subprocess
import os

import pysc

logger = logging.getLogger(__name__)


class PublishDoc(pysc.Application):

    defaults = {"config": "/etc/publish-doc.yml"}

    def main(self):
        import salt.syspaths as syspaths
        import salt.config
        import salt.client

        config = self.config
        virtualenv = config["virtualenv"]

        minion_config_file = config.get(
            "minion_config_file", os.path.join(syspaths.CONFIG_DIR, 'minion'))

        opts = salt.config.client_config(minion_config_file)
        caller = salt.client.Caller(minion_config_file)

        # get latest docs
        if opts.get("file_client") != "local":
            logger.debug("Running cp.cache_master")
            caller.sminion.functions["cp.cache_master"](
                saltenv=config["saltenv"])

        # build docs
        env = os.environ
        env["VIRTUAL_ENV"] = virtualenv
        subprocess.check_call(
            [os.path.join(virtualenv, "bin", "python"),
             os.path.join("doc", "build.py"),
             config["output"]],
            cwd=config["cwd"],
            env=env,
        )

if __name__ == "__main__":
    PublishDoc().run()
