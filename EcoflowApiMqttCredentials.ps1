# Configuration
$ACCESS_KEY = "Access Key from Ecoflow Dev Portal"
$SECRET_KEY = "Secret Key from Ecoflow Dev Portal"
$endpoint = "https://api-e.ecoflow.com"

function Get-Timestamp {
    return [int64](([datetime]::UtcNow - [datetime]'1970-01-01').TotalMilliseconds)
}

function Get-Nonce {
    return (Get-Random -Minimum 100000 -Maximum 999999).ToString()
}

function Get-Signature {
    param (
        [string]$access_key,
        [string]$secret_key,
        [string]$nonce,
        [string]$timestamp
    )
    
    $strToSign = "accessKey=$access_key&nonce=$nonce&timestamp=$timestamp"
    
    # Create HMAC-SHA256 signature
    $hmac = New-Object System.Security.Cryptography.HMACSHA256
    $hmac.Key = [System.Text.Encoding]::UTF8.GetBytes($secret_key)
    $signBytes = $hmac.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($strToSign))
    $signature = -join ($signBytes | ForEach-Object { "{0:x2}" -f $_ })
    
    return $signature
}

function Get-MqttConnectionData {
    $nonce = Get-Nonce
    $timestamp = Get-Timestamp
       
    # Generate the signature
    $sign = Get-Signature -access_key $ACCESS_KEY -secret_key $SECRET_KEY -nonce $nonce -timestamp $timestamp
    
    $headers = @{
        "accessKey" = $ACCESS_KEY
        "nonce" = $nonce
        "timestamp" = $timestamp
        "sign" = $sign
    }
    
    $url = "$endpoint/iot-open/sign/certification"
    
    # Send request
    return Invoke-RestMethod -Uri $url -Method Get -Headers $headers
}

$connectionData = Get-MqttConnectionData
$connectionData
