param (
    [Parameter(Mandatory=$true)]
    [string]$m,  # Mode: split or restore

    [Parameter(Mandatory=$true)]
    [string]$f   # File path for operations
)

function split($path) {
	
	$bytes = Get-Content $path -Encoding Byte
	$base64Content = [Convert]::ToBase64String($bytes)

	$outputBaseName = "chunk_"

	# Determine the size of each chunk in characters (approx. 100KB for Base64 encoding)
	$chunkSize = 100 * 1024 * 0.75  # Base64 inflates the size by approx. 33%, so we account for that

	# Initialize counters
	$startIndex = 0
	$chunkCounter = 1

	# Extract chunks
	while ($startIndex -lt $base64Content.Length) {
		$chunk = $base64Content.Substring($startIndex, [Math]::Min($chunkSize, $base64Content.Length - $startIndex))
		$outputPath = "${outputBaseName}${chunkCounter}.txt"
		Set-Content -Path $outputPath -Value $chunk
		Write-Output "Created: ${outputBaseName}${chunkCounter}.txt"
		$startIndex += $chunk.Length
		$chunkCounter++
	}
}

function restore($path) {
    # Get all chunk files sorted by chunk number to ensure correct order of assembly
    $files = Get-ChildItem -Filter "chunk_*.txt" | Sort-Object { [int]($_.Name -replace 'chunk_|\.txt', '') }

    $data = [System.Collections.ArrayList]::new()

    foreach ($file in $files) {
        $content = [System.IO.File]::ReadAllText($file.FullName)
        $bytes = [Convert]::FromBase64String($content)
        $data.AddRange($bytes)
    }

    [System.IO.File]::WriteAllBytes($path, $data.ToArray())
}

switch ($m) {
    "split" {
        split -path $f
        Write-Host "Split operation completed."
    }
    "restore" {
        restore -path $f
        Write-Host "Restore operation completed."
    }
    default {
        Write-Host "Invalid mode selected. Use 'split' or 'restore'."
    }
}
