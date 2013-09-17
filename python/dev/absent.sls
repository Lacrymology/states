{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
 python-dev:
  pkg:
    - purged
    - name: python{{ grains['pythonversion'][0] }}.{{ grains['pythonversion'][1] }}-dev
