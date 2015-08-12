#!/usr/local/piwik/bin/python
# -*- coding: utf-8 -*-

import logging

import bs4
import mechanicalsoup
import requests

import pysc

logger = logging.getLogger(__name__)


def _add_soup(response):
    '''explicit pass markup parser lib to bs4 avoid warning
    '''
    if 'text/html' in response.headers.get('Content-Type', ''):
        try:
            response.soup = bs4.BeautifulSoup(
                response.content, 'html.parser')
        except:
            pass


def _raise_on_failure(resp):
    '''check if response object have alert-success message, if not raise
    error

    '''
    if len(resp.soup.select('.alert.alert-success')) == 0:
        raise ValueError('No success alert in reponse body')


class InitializePiwik(pysc.Application):
    def get_argument_parser(self):
        argp = super(InitializePiwik, self).get_argument_parser()
        argp.add_argument(
            '--url', type=str, required=True, help='piwik install URL')
        argp.add_argument(
            '--database-user', type=str, default='piwik',
            help='piwik MySQL database user')
        argp.add_argument(
            '--database-password', type=str, required=True,
            help='piwik MySQL database password')
        argp.add_argument(
            '--database-name', type=str, default='piwik',
            help='piwik MySQL database name')
        argp.add_argument(
            '--user', type=str, required=True,
            help='piwik initial admin username')
        argp.add_argument(
            '--password', type=str, required=True,
            help='piwik initial admin password')
        argp.add_argument(
            '--email', type=str, required=True,
            help='piwik initial admin email')
        argp.add_argument(
            '--dummy-website-name', type=str,
            default='DUMMY WEBSITE - DELETE ME',
            help='piwik dummy website name to complete setup')
        argp.add_argument(
            '--dummy-website-url', type=str,
            default='http://dummy.local',
            help='piwik dummy website URL to complete setup')
        argp.add_argument(
            '--test', action='store_true',
            help='Run in test mode: disable SSL verification')

        return argp

    def main(self):

        c = self.config

        # disable SSL verification if --test is passed
        verify = True
        if c['test']:
            # disable warning: InsecureRequestWarning: Unverified HTTPS
            # request is being made.
            requests.packages.urllib3.disable_warnings()
            verify = False

        # monkey patch to disable following warning
        # UserWarning: No parser was explicitly specified, so I'm using
        # the best available HTML parser for this system
        # ("html.parser"). This usually isn't a problem, but if you run
        # this code on another system, or in a different virtual
        # environment, it may use a different parser and behave
        # differently.
        mechanicalsoup.Browser.add_soup = staticmethod(_add_soup)

        browser = mechanicalsoup.Browser()

        # fill database information form
        db_setup_url = 'index.php?action=databaseSetup&trackerStatus=0'
        db_setup_page = browser.get(
            '/'.join([c['url'], db_setup_url]), verify=verify)
        logger.debug('db_setup_page: %s', db_setup_page.text)
        db_setup_form = db_setup_page.soup.select('#databasesetupform')[0]
        db_setup_form.select(
            '#username-0')[0]['value'] = c['database_user']
        db_setup_form.select(
            '#password-0')[0]['value'] = c['database_password']
        db_setup_form.select(
            '#dbname-0')[0]['value'] = c['database_name']

        # check if tables creation is success
        create_tables_page = browser.submit(db_setup_form, db_setup_page.url)
        logger.debug('create_tables_page: %s', create_tables_page.text)
        _raise_on_failure(create_tables_page)
        super_user_url = create_tables_page.soup.select(
            'a.btn.btn-lg')[0]['href']

        # create super user
        super_user_page = browser.get(
            '/'.join([c['url'], super_user_url]), verify=verify)
        logger.debug('super_user_page: %s', super_user_page.text)
        super_user_form = super_user_page.soup.select('#generalsetupform')[0]
        super_user_form.select('#login-0')[0]['value'] = c['user']
        super_user_form.select('#password-0')[0]['value'] = c['password']
        super_user_form.select('#password_bis-0')[0]['value'] = c['password']
        super_user_form.select('#email-0')[0]['value'] = c['email']
        super_user_form.select(
            '#subscribe_newsletter_piwikorg-0')[0]['checked'] = False
        super_user_form.select(
            '#subscribe_newsletter_piwikpro-0')[0]['checked'] = False

        # Piwik requires to setup a website to complete the installation
        # Setup a fake one
        setup_website_page = browser.submit(
            super_user_form, super_user_page.url)
        logger.debug('setup_website_page: %s', setup_website_page.text)
        _raise_on_failure(setup_website_page)
        setup_website_form = setup_website_page.soup.select(
            '#websitesetupform')[0]
        setup_website_form.select(
            '#siteName-0')[0]['value'] = c['dummy_website_name']
        setup_website_form.select(
            '#url-0')[0]['value'] = c['dummy_website_url']
        # set first valid time zone
        setup_website_form.select(
            '#timezone-0 > optgroup > option')[0]['selected'] = True

        # JavaScript Tracking Code page
        js_tracking_code_page = browser.submit(
            setup_website_form, setup_website_page.url)
        logger.debug('js_tracking_code_page: %s', js_tracking_code_page.text)
        _raise_on_failure(js_tracking_code_page)
        congratulations_url = create_tables_page.soup.select(
            'a.btn.btn-lg')[0]['href']

        # Congratulations page
        congratulations_page = browser.get(
            '/'.join([c['url'], congratulations_url]), verify=verify)
        logger.debug('congratulations_page: %s', congratulations_page.text)
        complete_form = congratulations_page.soup.select(
            '#defaultsettingsform')[0]
        browser.submit(complete_form, congratulations_page.url)


if __name__ == '__main__':
    InitializePiwik().run()
