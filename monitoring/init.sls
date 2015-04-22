/var/containers/monitoring/docker-compose.yml:
  file.managed:
    - source: salt://monitoring/docker-compose.yml
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

/var/log/containers:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/logrotate.d/containers:
  file.managed:
    - source: salt://monitoring/containers
    - user: root
    - group: root
    - mode: 644

progrium/logspout:
  docker.pulled:
    - tag: latest
    - force: True

tptee/rsyslog-file:
  docker.pulled:
    - tag: latest
    - force: True

flush-monitoring:
  cmd.run:
    - name: |
        docker-compose stop
        docker-compose rm --force
        docker-compose up -d
    - cwd: /var/containers/monitoring
    - watch:
        - docker: progrium/logspout
        - docker: tptee/rsyslog-file
