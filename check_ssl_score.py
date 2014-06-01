#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Copyright (c) 2013, Quan Tong Anh
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
Nagios plugin to check the SSL configuration of a server.
This is calculated based on Qualys Server Rating Guide: https://www.ssllabs.com/projects/rating-guide/
"""

__author__ = 'Quan Tong Anh'
__maintainer__ = 'Quan Tong Anh'
__email__ = 'quanta@robotinfra.com'

import os
import sys
import argparse
import subprocess
from lxml import etree
import nagiosplugin as nap
from datetime import datetime


class SslConfiguration(nap.Resource):
    def probe(self):
        DEVNULL = open(os.devnull, 'wb')
        sslyze_command = "/usr/local/bin/sslyze.py --regular --xml_out='/tmp/{0}_{1}_sslyze.xml' {0}:{1}".format(host, port)
        stderr = subprocess.Popen(sslyze_command, stdout=DEVNULL, shell=True).communicate()[1]
        
        if stderr is None:
            root = etree.parse("/tmp/{0}_{1}_sslyze.xml".format(host, port))
            
            hostnameValidation = root.xpath("//hostnameValidation[@certificateMatchesServerHostname]")
            certificateMatchesServerHostname = hostnameValidation[0].attrib['certificateMatchesServerHostname']

            notAfter = root.xpath("//certificate/validity/notAfter")
            expire_date = datetime.strptime(notAfter[0].text, "%b %d %H:%M:%S %Y %Z")
            expire_in = expire_date - datetime.now()

            validationResult = 'ok'
            pathValidation = root.xpath("//certificateValidation/pathValidation")
            for p in pathValidation:
                if p.attrib['validationResult'] != 'ok':
                    validationResult = p.attrib['validationResult']
                    break
                
            if certificateMatchesServerHostname == 'True' and expire_in.days > 0 and validationResult == 'ok':
                protocol_scores = {'sslv2': 0, 'sslv3': 80, 'tlsv1': 90, 'tlsv1_1': 95, 'tlsv1_2': 100}
                protocols = sorted(protocol_scores.keys())
                
                for k in reversed(protocols):
                    if len(root.xpath("//{0}/acceptedCipherSuites/cipherSuite".format(k))) > 0:
                        best_protocol = k
                        break
                
                for k in protocols:
                    if len(root.xpath("//{0}/acceptedCipherSuites/cipherSuite".format(k))) > 0:
                        worst_protocol = k
                        break
                
                protocol_score = (protocol_scores[worst_protocol] + protocol_scores[best_protocol]) / 2
                
                key_scores = {(0,512): 20, (512, 1024): 40, (1024, 2048): 80, (2048, 4096): 90, (4096, 16384): 100}
                publicKeySize = root.xpath("//publicKeySize")
                key_size = publicKeySize[0].text.split()[0]
                
                # This must be updated when this one is merged: https://github.com/iSECPartners/sslyze/pull/70
                dh_param_strength = 1024
            
                for k, v in key_scores.iteritems():
                    if k[0] <= min(int(key_size), dh_param_strength) and min(int(key_size), dh_param_strength) < k[1]:
                        key_score = key_scores[k]
                        break
                
                cipher_strength = root.xpath("//acceptedCipherSuites/cipherSuite")
                keySizes = []
    
                for c in cipher_strength:
                    # https://github.com/iSECPartners/sslyze/issues/71
                    if c.attrib['keySize'] != 'Anon':
                        keySizes.append(c.attrib['keySize'])
                
                weakest_cipher_strength = sorted(keySizes)[0].split()[0]
                strongest_cipher_strength = sorted(keySizes)[-1].split()[0]
    
                cipher_scores = {(0, 128): 20, (128, 256): 80, (256,16384): 100}
                for k, v in cipher_scores.iteritems():
                    if k[0] <= int(weakest_cipher_strength) and int(weakest_cipher_strength) < k[1]:
                        weakest_cipher_score = cipher_scores[k]
                        break
                
                for k, v in cipher_scores.iteritems():
                    if k[0] <= int(strongest_cipher_strength) and int(strongest_cipher_strength) < k[1]:
                        strongest_cipher_score = cipher_scores[k]
                        break
                
                cipher_score = (weakest_cipher_score + strongest_cipher_score) / 2
                
                final_score = protocol_score * 0.3 + key_score * 0.3 + cipher_score * 0.4
                return [nap.Metric('sslscore', final_score, min=0, max=100)]
            elif certificateMatchesServerHostname != 'True':
                return [nap.Metric('serverHostname', hostnameValidation[0].attrib['serverHostname'])]
            elif expire_in.days <= 0:
                return [nap.Metric('expireInDays', expire_in.days)]
            elif validationResult != 'ok':
                return [nap.Metric('validationResult', validationResult)]


@nap.guarded
def main():
    check = nap.Check(
        SslConfiguration(),
        nap.ScalarContext('sslscore', nap.Range('@65:80'), nap.Range('@0:65')),
        nap.ScalarContext('serverHostname', fmt_metric='The certificate does not match the host name {value}'),
        nap.ScalarContext('expireInDays', nap.Range('@:0'), fmt_metric='The certificate expired {value} days ago'),
        nap.ScalarContext('validationResult', fmt_metric='This server\'s certificate is not trusted: {value}'))
    check.main(timeout=60)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-H', '--hostname', type=str, required=True)
    parser.add_argument('-p', '--port', type=int, default=443)
    args = parser.parse_args()
    host = args.hostname
    port = args.port

    main()
