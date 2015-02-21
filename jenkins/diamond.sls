{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - cron.diamond
  - diamond
  - nginx.diamond

jenkins_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[jenkins]]
        cmdline = \/usr\/bin\/daemon --name=jenkins,\/usr\/bin\/java -jar \/usr\/share\/jenkins\/jenkins.war
