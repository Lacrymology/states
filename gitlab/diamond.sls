{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - nginx.diamond
  - nodejs.diamond
  - postgresql.server.diamond
  - redis.diamond
  - ssh.server.diamond

gitlab_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[gitlab-sidekiq]]
        cmdline = ^sidekiq.+gitlabhq
        [[gitlab-unicorn]]
        cmdline = unicorn_rails
        [[gitlab-git-http-server]]
        name = gitlab-git-http
