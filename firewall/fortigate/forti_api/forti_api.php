#!/usr/bin/php
<?php

function get_time() {
    list($usec, $sec) = explode(" ", microtime());
    return ((float)$usec + (float)$sec);
}

function fn_forti_login ($fw_ip, $username, $secretkey, $method, $url, $data='') {
	
	$temp_file = tempnam(sys_get_temp_dir(), 'curl_cookie');

	### login ###
	$ch = curl_init();
	
	//curl_setopt ($ch, CURLOPT_TIMEOUT, 4); //execution timeout
	curl_setopt ($ch, CURLOPT_SSL_VERIFYHOST, 0); //인증서 체크
	curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE); // 인증서 체크
	curl_setopt ($ch, CURLOPT_SSLVERSION, 0); // SSL 버젼
	curl_setopt ($ch, CURLOPT_HEADER, 1); // 헤더 출력 여부
	curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1); // 결과값을 받을것인지

	curl_setopt ($ch, CURLOPT_URL, "https://".$fw_ip."/logincheck" );
	curl_setopt ($ch, CURLOPT_POST, 1); // Post
	curl_setopt ($ch, CURLOPT_POSTFIELDS, "username=".$username."&secretkey=".$secretkey);
	curl_setopt ($ch, CURLOPT_COOKIEJAR, $temp_file); //cookie 저장

	$result = curl_exec ($ch);

	$curl_info = curl_getinfo($ch);
	$curl_error[0] = curl_errno($ch);
	$curl_error[1] = curl_error($ch);
	curl_close ($ch);
	$header_size = $curl_info['header_size'];
	$header = substr($result, 0, $header_size);
	$body = substr($result, $header_size);

	#echo "<pre>"; print_r($curl_info); echo "</pre>";
	#echo "<pre>"; var_dump($curl_error); echo "</pre>";

	if ( preg_match("/ccsrftoken=\"(\w+)\";/", $header, $match) ) {
		$header_add = array('Content-Type: application/json', 'X-CSRFTOKEN:'.$match[1] );
		$out['temp_file'] = $temp_file;
		$out['header_add'] = $header_add;
		return $out;
	} else if ( $curl_error[0] > 0 ) {
		$out[0] = "Curl Error : ".$curl_error[0]." ".$curl_error[1];
		$out['url'] = $curl_info['url'];
		$out['http_code'] = $curl_info['http_code'];
		$out['body'] = $body;
		$out['time'] = $curl_info['total_time'];
		return $out;
	} else {
		$out[0] = "Authentication Error";
		$out['url'] = $curl_info['url'];
		$out['http_code'] = $curl_info['http_code'];
		$out['body'] = $body;
		$out['time'] = $curl_info['total_time'];
		$out['temp_file'] = $temp_file;
		return $out;
	}
}

function fn_forti ($fw_ip, $username, $secretkey, $method, $url, $data='', $temp_file, $header_add) {

	#### api 실행 ###
	$ch = curl_init();

	curl_setopt ($ch, CURLOPT_SSL_VERIFYHOST, 0); //인증서 체크
	curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE); // 인증서 체크
	curl_setopt ($ch, CURLOPT_SSLVERSION, 0); // SSL 버젼
	curl_setopt ($ch, CURLOPT_HEADER, 1); // 헤더 출력 여부
	curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1); // 결과값을 받을것인지
	curl_setopt ($ch, CURLOPT_COOKIEFILE, $temp_file); //cookie 이용

	if (strtoupper($method) == "POST") {
		//echo $data;
		curl_setopt ($ch, CURLOPT_POST, 1);
		curl_setopt ($ch, CURLOPT_POSTFIELDS, $data);
		curl_setopt ($ch, CURLOPT_HTTPHEADER, $header_add);
	} else if (strtoupper($method) == "PUT") {
		curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PUT');
		curl_setopt ($ch, CURLOPT_POSTFIELDS, $data);
		curl_setopt ($ch, CURLOPT_HTTPHEADER, $header_add);
	}

	curl_setopt($ch, CURLOPT_URL, "https://".$fw_ip.$url );

	$result = curl_exec ($ch);

	$curl_info = curl_getinfo($ch);
	$curl_error[0] = curl_errno($ch);
	$curl_error[1] = curl_error($ch);
	curl_close ($ch);
	$header_size = $curl_info['header_size'];
	$header = substr($result, 0, $header_size);
	$body = substr($result, $header_size);
	//print_r($curl_info);

	#### Return Value ####

	if ( $curl_error[0] > 0 ) $out[0] = "Curl Error : ".$curl_error[0]." ".$curl_error[1]; else $out[0] = 'no curl error';
	$out['url'] = $curl_info['url'];
	$out['http_code'] = $curl_info['http_code'];
	$out['body'] = $body;
	$out['time'] = $curl_info['total_time'];
	return $out;

}

function fn_forti_logout ($fw_ip, $username, $secretkey, $method, $url, $data='', $temp_file, $header_add) {

	#### logout ###
	$ch = curl_init();

	curl_setopt ($ch, CURLOPT_SSL_VERIFYHOST, 0); //인증서 체크
	curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE); // 인증서 체크
	curl_setopt ($ch, CURLOPT_SSLVERSION, 0); // SSL 버젼
	curl_setopt ($ch, CURLOPT_HEADER, 1); // 헤더 출력 여부
	curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1); // 결과값을 받을것인지
	curl_setopt ($ch, CURLOPT_COOKIEFILE, $temp_file); //cookie 이용
	curl_setopt ($ch, CURLOPT_COOKIEJAR, $temp_file); //cookie 저장

	curl_setopt($ch, CURLOPT_URL, "https://".$fw_ip."/logout" );

	$result = curl_exec ($ch);
	//$curl_info = curl_getinfo($ch);
	curl_close ($ch);
	unlink($temp_file);

	#### Return Value ####

	if ( $curl_error[0] > 0 ) $out[0] = "Curl Error : ".$curl_error[0]." ".$curl_error[1]; else $out[0] = 'no curl error';
	$out['url'] = $curl_info['url'];
	$out['http_code'] = $curl_info['http_code'];
	$out['body'] = $body;
	$out['time'] = $curl_info['total_time'];
	return $out;
}

if ($argv[1] != '-ip' or $argv[3] != '-id' or $argv[5] != '-pw' or $argv[7] != '-data' ) {
	echo "\n실행방법 : ".$_SERVER['PHP_SELF']." -ip x.x.x.x -id admin -pw admin123 -data data.txt\n";
	echo "\ndata.txt 파일은 순번, Method, URL, Data 를 TAB 분리값으로 작성\n";
	echo "\n99	POST	/api/v2/cmdb/firewall/address?vdom=root	{ 'json': {'name':'7.1.1.99/32', 'type':'ipmask', 'subnet': '7.1.1.99 255.255.255.255'} }\n\n";
	exit;
}

if ($argv[1] == '-ip') $fw_ip = $argv[2];
if ($argv[3] == '-id') $fw_id = $argv[4];
if ($argv[5] == '-pw') $fw_pw = $argv[6];
if ($argv[7] == '-data') $data_file = $argv[8];
#if ($argv[9] == '-interval') $interval = (int)$argv[10];
$interval = 1;
#if ($argv[11] == '-errorstop' && $argv[12] == 'no') $errorstop = 'no'; else $errorstop = "yes";
$errorstop = "yes";

$fp = @fopen($data_file, "r");

if (!$fp) {
	echo "\n데이타 파일 오픈 실패!\n\n";
	exit;
} else { 
	echo "\n스크립트 시작!\n###순번 => HTTP 응답코드 => curl 실행시간 ### 로 결과값이 출력됩니다.\n\n";
}

$login = fn_forti_login ($fw_ip, $fw_id, $fw_pw, '', '', '');
$temp_file = $login['temp_file'] ;
$header_add = $login['header_add'];

if (isset($login[0])) {
	echo "\n".$login[0]."\n";
	exit;
} else {
	echo "로그인 성공 : ".$login['header_add'][1]."\n";
	#print_r($login);
}

while (!feof($fp)) {
	$data = fgets($fp, 4096);
	//$data = str_replace('""', '"', $data);
	//$data = str_replace('1000', $vdom, $data);
	$data = explode("\t", $data);
	#print_r($data);
	if ( count($data) < 3 ) continue;
	$result = fn_forti ($fw_ip, $fw_id, $fw_pw, $data[1], $data[2], substr($data[3], 1, -1), $temp_file, $header_add);
	echo $data[0]." => ".$result['http_code']." => ".$result['time'];
	if ($result[0] != 'no curl error') echo " => ".$result[0]."\n"; else echo "\n";
	echo $result['body']."\n\n";
	if ($result['http_code'] != 200) $error[$data[0]] = $result['http_code']." => ".$result['time']." => ".$result[0]."\n";
	if (!isset($time)) $time = 0;
	$time = $time + $result['time'];
	if ($result['http_code'] != 200 && $errorstop == "yes") {
		echo "### api http error code 가 발생되어 스크립트를 정지합니다. ###\n\n";
		/*echo "Fortigate API Error HTTP code:\n";
		echo "400 - Bad Request => Request cannot be processed by the API.\n";
		echo "401 - Not Authorized => Request without successful login session.\n";
		echo "403 - Forbidden => Request is missing CSRF token or administrator is missing access profile permissions.\n";
		echo "404 - Resource Not Found => Unable to find the specified resource.\n";
		echo "405 - Method Not Allowed => Specified HTTP method is not allowed for this resource.\n";
		echo "413 - Request Entity Too Large => Request cannot be processed due to large entity.\n";
		echo "424 - Failed Dependency => Fail dependency can be duplicate resource, missing required parameter, missing required attribute, invalid attribute value.\n";
		echo "500 - Internal Server Error => Internal error when processing the request.\n";*/
		$logout = fn_forti_logout ($fw_ip, $fw_id, $fw_pw, '', '', '', $temp_file, $header_add);
		exit;
	}
	unset($result);
	sleep($interval);
}

$logout = fn_forti_logout ($fw_ip, $fw_id, $fw_pw, '', '', '', $temp_file, $header_add);

if (is_array($error)) {
	echo "\n### error 발생 리스트 ###\n\n";
	foreach ($error as $key => $value) {
		echo "error : ".$key." => ".$value;
	}
	echo "\n전체 error 수량 : ".count($error)."\n";
}

echo "\n\ntotal curl execution time = ".$time."\n\n";

/*echo "Fortigate API Error HTTP code:\n";
echo "400 - Bad Request => Request cannot be processed by the API.\n";
echo "401 - Not Authorized => Request without successful login session.\n";
echo "403 - Forbidden => Request is missing CSRF token or administrator is missing access profile permissions.\n";
echo "404 - Resource Not Found => Unable to find the specified resource.\n";
echo "405 - Method Not Allowed => Specified HTTP method is not allowed for this resource.\n";
echo "413 - Request Entity Too Large => Request cannot be processed due to large entity.\n";
echo "424 - Failed Dependency => Fail dependency can be duplicate resource, missing required parameter, missing required attribute, invalid attribute value.\n";
echo "500 - Internal Server Error => Internal error when processing the request.\n";*/
?>
