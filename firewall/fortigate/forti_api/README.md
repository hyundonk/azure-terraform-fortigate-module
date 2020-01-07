## Using Fortigate API to on/off health probe response

**Running this script:**
1. install php on a linux (e.g. ubuntu) machine: 
sudo apt-get -y  install php php-cli php-curl

2. Run below command to enable health probe response
```
php forti_api.php -ip 10.10.0.69:8443 -id <username> -pw <password> -data probe_on

스크립트 시작!
###순번 => HTTP 응답코드 => curl 실행시간 ### 로 결과값이 출력됩니다.

로그인 성공 : X-CSRFTOKEN:57F3937E49E54087771FFA14582AEA91
1 => 200 => 0.01045  <== 설정 수행
{
  "http_method":"PUT",
  "revision":"14.0.0.9544640476480679317.1578291647",
  "status":"success",
  "http_status":200,
  "vdom":"root",
  "path":"system",
  "name":"probe-response",
  "serial":"FGVM04TM19002096",
  "version":"v6.0.7",
  "build":5412
}

2 => 200 => 0.011162  <== 설정결과 확인
{
  "http_method":"GET",
  "revision":"14.0.0.9544640476480679317.1578291647",
  "results":{
    "port":8008,
    "http-probe-value":"OK",
    "ttl-mode":"retain",
    "mode":"http-probe", <== http-probe 이면 on
    "security-mode":"none",
    "password":"",
    "timeout":300
  },
  "vdom":"root",
  "path":"system",
  "name":"probe-response",
  "status":"success",
  "http_status":200,
  "serial":"FGVM04TM00000000",
  "version":"v6.0.7",
  "build":5412
}
```

3. Run below command to disable health probe response
```
php forti_api.php -ip 10.10.0.69:8443 -id <username> -pw <password> -data probe_off

스크립트 시작!
###순번 => HTTP 응답코드 => curl 실행시간 ### 로 결과값이 출력됩니다.

로그인 성공 : X-CSRFTOKEN:FEA1A45FC5758C1B24923F58ABAEF
1 => 200 => 0.013665
{
  "http_method":"PUT",
  "revision":"14.0.0.9544640476480679317.1578291647",
  "status":"success",
  "http_status":200,
  "vdom":"root",
  "path":"system",
  "name":"probe-response",
  "serial":"FGVM04TM00000000",
  "version":"v6.0.7",
  "build":5412
}

2 => 200 => 0.01072
{
  "http_method":"GET",
  "revision":"15.0.0.9544640476480679317.1578291647",
  "results":{
    "port":8008,
    "http-probe-value":"OK",
    "ttl-mode":"retain",
    "mode":"none", <== none 이면 off  
    "security-mode":"none",
    "password":"",
    "timeout":300
  },
  "vdom":"root",
  "path":"system",
  "name":"probe-response",
  "status":"success",
  "http_status":200,
  "serial":"FGVM04TM19002096",
  "version":"v6.0.7",
  "build":5412
}
```
