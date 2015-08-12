#!/usr/local/piwik/bin/python

import argparse

import bs4
import mechanicalsoup
import requests

DATABASE_USERNAME = 'piwik'
DATABASE_NAME = 'piwik'
DUMMY_WEBSITE_NAME = 'DUMMY WEBSITE - DELETE ME'
DUMMY_WEBSITE_URL = 'http://dummy.local'


def _parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--url', type=str, required=True, help='piwik install URL')
    parser.add_argument(
        '--database-password', type=str, required=True,
        help='piwik MySQL database password')
    parser.add_argument(
        '--user', type=str, required=True, help='piwik initial admin username')
    parser.add_argument(
        '--password', type=str, required=True,
        help='piwik initial admin password')
    parser.add_argument(
        '--email', type=str, required=True,
        help='piwik initial admin email')
    parser.add_argument(
        "--test", help="Run in test mode: disable SSL verification",
        action="store_true")
    return parser.parse_args()


def _add_soup(response):
    if 'text/html' in response.headers.get('Content-Type', ''):
        try:
            response.soup = bs4.BeautifulSoup(
                response.content, 'html.parser')
        except:
            pass

if __name__ == '__main__':
    args = _parse_args()
    verify = False if args.test else True
    if args.test:
        # disable warning: InsecureRequestWarning: Unverified HTTPS
        # request is being made.
        requests.packages.urllib3.disable_warnings()

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
        '/'.join([args.url, db_setup_url]), verify=verify)
    db_setup_form = db_setup_page.soup.select('#databasesetupform')[0]
    db_setup_form.select('#username-0')[0]['value'] = DATABASE_USERNAME
    db_setup_form.select('#password-0')[0]['value'] = args.database_password
    db_setup_form.select('#dbname-0')[0]['value'] = DATABASE_NAME

    # check if tables creation is success
    create_tables_page = browser.submit(db_setup_form, db_setup_page.url)
    if len(create_tables_page.soup.select('.alert.alert-success')) == 0:
        raise ValueError('No success alert in reponse body')
    super_user_url = create_tables_page.soup.select('a.btn.btn-lg')[0]['href']

    # create super user
    super_user_page = browser.get(
        '/'.join([args.url, super_user_url]), verify=verify)
    super_user_form = super_user_page.soup.select('#generalsetupform')[0]
    super_user_form.select('#login-0')[0]['value'] = args.user
    super_user_form.select('#password-0')[0]['value'] = args.password
    super_user_form.select('#password_bis-0')[0]['value'] = args.password
    super_user_form.select('#email-0')[0]['value'] = args.email
    super_user_form.select(
        '#subscribe_newsletter_piwikorg-0')[0]['checked'] = False
    super_user_form.select(
        '#subscribe_newsletter_piwikpro-0')[0]['checked'] = False

    # Piwik requires to setup a website to complete the installation
    # Setup a fake one
    setup_website_page = browser.submit(super_user_form, super_user_page.url)
    if len(setup_website_page.soup.select('.alert.alert-success')) == 0:
        raise ValueError('No success alert in reponse body')
    setup_website_form = setup_website_page.soup.select('#websitesetupform')[0]
    setup_website_form.select('#siteName-0')[0]['value'] = DUMMY_WEBSITE_NAME
    setup_website_form.select('#url-0')[0]['value'] = DUMMY_WEBSITE_URL
    # set first valid time zone
    setup_website_form.select(
        '#timezone-0 > optgroup > option')[0]['selected'] = True

    # JavaScript Tracking Code page
    js_tracking_code_page = browser.submit(
        setup_website_form, setup_website_page.url)
    if len(js_tracking_code_page.soup.select('.alert.alert-success')) == 0:
        raise ValueError('No success alert in reponse body')
    congratulations_url = create_tables_page.soup.select(
        'a.btn.btn-lg')[0]['href']

    # Congratulations page
    congratulations_page = browser.get(
        '/'.join([args.url, congratulations_url]), verify=verify)
    complete_form = congratulations_page.soup.select('#defaultsettingsform')[0]
    browser.submit(complete_form, congratulations_page.url)
