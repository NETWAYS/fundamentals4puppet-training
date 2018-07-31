useradd -g vagrant -d /home/training -m training -s /bin/bash 2>/dev/null
sed -i 's|^training:.*$|training:$6$6kKwWz2c$eVYoDNonqIItGB9hsapr5LX3NkOM4sySMX189ABgAayxXYV1MnoUjt2zAQbvhN9pW/RfsQS8Z/iWGa0nCByRD0:17455:0:99999:7:::|g' /etc/shadow
install -o training -g vagrant -m700 -d /home/training/.ssh

echo "-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA95WHOCOte5V4fJQM+ZOwf25x9YHHmfOVJ+dFAT+/IL8pklU+
quwga0g6sh/p9AbKO8x0F+adwW5hYiLlquY7JCf+qnOdyy7sztzIuIdksBMIV55Z
7LdW4L5MTcB+qy6Xd1vuPI/o52MG9GDiMZXWW+uzGT1E+26ZTMFkzGlis9YuaiFi
tp05iZEgKeb1hQKK7Jen2vg7QvCHd6W7eeE1MYwOi+22fcWJmtkjWr9GELHOFhbQ
lGc+f7kkkZWEDBTuQ8MCI0jeJlxpsRwrSPt1pjA1xNSlCeUuYnwtNaj/SbO2Aj9K
sjCU2ot/U/vtDWGV41aVsqLPQzp7ivWOov1ouwIDAQABAoIBAQCNggeBTNMROcNd
4PjxhTpx+1xjKEQ/d/uejQ7hwd+qBdjq7JIe+0skRmpV+OutMFxShW8tYgB02HQM
tUlzvpe6+KkUH3Tm9vEe4w5OegRQpvAztCxNohSj6+CM6CL+EGk+LWsjblV+Oxl0
gBOIp82XSEZbfKt60iIIvtiwBOQHSJn28N0PXhG308fYjTsh+CAo9vS6F0Dtz7df
UsiCxiOdBmbQ6U1b46YC+nlBXZKdKw3ZguliMC/gM9cOWIZ0GBTBDPjg/EYFMbnE
rgRWVB8MtUfowzNABQcivA4RhvEyhAENUZeJjks7IxwJGs6MAgaWHlmXC3xKkD1e
wSzI8FDhAoGBAP/YdnKg/LabxkbqTUuG1GaWKjY6HMkV/z3x9JMSviAPlPazgLNL
JGwLQoPm7peEzRHrHnCtM+l21iN6KosL8XClO11Ex8kEYnZdSV+oBezEPujAlHOg
Gm775yxoiGC9l9cr14xrkPUl0/0J69Q7UWCWBieBvVYSU54RW7ybe6u5AoGBAPe7
yfA0tycoh6tjS55FSiJqosRwguhAbfpmqcOkA0JhsDVqVniW78d4tCjBSIrTQn61
s6R/n1rh2d1xQEQwAKg+d/BxgKpl3sjJsIjsZKo9+KZ9weUJyBMKbv+ybPeoKZHD
wb7UFNq7I4Yyc41olBfG2W7n6YKbvveByN78hfoTAoGAUmTx8ISsHlsYheobLoGj
kc42lfQtJQ1ygA6WB293z3d1L+YrQpKmji0qJLSQjjd0m5qu2PbOyxc8a3yCivkz
rmVoMuddt/0zgI8WfDnufovM/sRWis469RcnIgQgN5eXePJjnpNdwbWHCezSCC16
TbLDFKIRydBpIXTRqHIiZ/ECgYA2yMuOmEnMmhTunOXTGWWcmNJn+K2qaN0pW9y9
DB9AZdQO6/Y1csOR7CqDPMMrGC8DUHFqtmJqObnxU6MvsSHkEvR5MtCOXjrXUmr8
zLIyR8QeJX9khDY/p7YGS9H3LrQKrSzCY6o8+NeRTMTrB66AV5QsB5NHM+QWXhgq
39NNCwKBgQCyqHAiozhDTnp1+WX+gy2n2I5bgmTMOMaXBz8tlB8VDBJEsMCY611w
fjS+9rDH2ayxjZRJLFrv9O2lyFIYDcTUh8j3nhnQXK/prJDH6+y9EQ6IDDYW9Vrh
l/zBfTzjQaADBBdUqx7pThEwuffduGcdudIMdl74Wm/sLKM9Fm624g==
-----END RSA PRIVATE KEY-----" > /home/training/.ssh/id_rsa

chown training.vagrant /home/training/.ssh/id_rsa; chmod 600 /home/training/.ssh/id_rsa
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3lYc4I617lXh8lAz5k7B/bnH1gceZ85Un50UBP78gvymSVT6q7CBrSDqyH+n0Bso7zHQX5p3BbmFiIuWq5jskJ/6qc53LLuzO3Mi4h2SwEwhXnlnst1bgvkxNwH6rLpd3W+48j+jnYwb0YOIxldZb67MZPUT7bplMwWTMaWKz1i5qIWK2nTmJkSAp5vWFAorsl6fa+DtC8Id3pbt54TUxjA6L7bZ9xYma2SNav0YQsc4WFtCUZz5/uSSRlYQMFO5DwwIjSN4mXGmxHCtI+3WmMDXE1KUJ5S5ifC01qP9Js7YCP0qyMJTai39T++0NYZXjVpWyos9DOnuK9Y6i/Wi7 training@agent" > /home/training/.ssh/id_rsa.pub
chown training.vagrant /home/training/.ssh/id_rsa.pub; chmod 600 /home/training/.ssh/id_rsa.pub
grep 192.168.56.101 || echo '192.168.56.101       puppet.localdomain      puppet' >> /etc/hosts

if [ "X${1}" == "Xgit-init" ]; then
  stat /home/training/puppet/.git 2>&1>/dev/null || sudo -u training bash -c 'git init /home/training/puppet;cd /home/training/puppet; git remote add origin git@puppet.localdomain:puppet.git'
  sudo -u training bash -c 'cd /home/training; git config --global user.email "training@localdomain"; git config --global user.name "Netways Training"'
fi
