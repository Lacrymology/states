{#-
Copyright (c) 2013, Lam Dang Tung

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Author: Lam Dang Tung <lamdt@familug.org>
Maintainer: Lam Dang Tung <lamdt@familug.org>

Install RetroShare - commmunication and sharing platform.
-#}

include:
  - apt
  - tightvncserver

retroshare:
  pkgrepo:
    - managed
{%- set version = salt['pillar.get']('retroshare:version', '0.5.5-0.6732') -%}
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive'] }}/mirror/retroshare/{{ version }} {{ grains['lsb_codename'] }} main
{%- else %}
    - name: deb http://archive.robotinfra.com/mirror/retroshare/{{ version }} {{ grains['lsb_codename'] }} main
{%- endif %}
    - keyid: 2E10C9E3
    - keyserver: keyserver.ubuntu.com
    - file: /etc/apt/sources.list.d/retroshare.list
    - require:
      - pkg: python-apt
      - pkg: python-software-properties
  pkg:
    - installed
    - pkgs:
      - libicu48
      - retroshare
    - require:
      - pkgrepo: retroshare
      - pkg: tightvncserver

