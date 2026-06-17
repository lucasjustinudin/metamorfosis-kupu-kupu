Add-Type -AssemblyName System.Drawing

function New-ButterflyIcon {
    param(
        [int]$size,
        [string]$path,
        [double]$scale = 0.85
    )

    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

    # Soft pink background (solid for maskable safety)
    $bg = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 179, 198))
    $g.FillRectangle($bg, 0, 0, $size, $size)

    $cx = $size / 2
    $cy = $size / 2
    $s = $size * $scale

    # Top wings (darker pink)
    $wing1 = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 107, 157))
    $g.FillEllipse($wing1, $cx - $s*0.42, $cy - $s*0.38, $s*0.38, $s*0.34)
    $g.FillEllipse($wing1, $cx + $s*0.04, $cy - $s*0.38, $s*0.38, $s*0.34)

    # Bottom wings (yellow)
    $wing2 = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 215, 100))
    $g.FillEllipse($wing2, $cx - $s*0.36, $cy - $s*0.05, $s*0.30, $s*0.28)
    $g.FillEllipse($wing2, $cx + $s*0.06, $cy - $s*0.05, $s*0.30, $s*0.28)

    # Wing decorations (small lavender dots)
    $dot = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 212, 184, 224))
    $dotSize = [Math]::Max(2, $s*0.04)
    $g.FillEllipse($dot, $cx - $s*0.30, $cy - $s*0.25, $dotSize, $dotSize)
    $g.FillEllipse($dot, $cx + $s*0.26, $cy - $s*0.25, $dotSize, $dotSize)
    $g.FillEllipse($dot, $cx - $s*0.26, $cy + $s*0.06, $dotSize*0.8, $dotSize*0.8)
    $g.FillEllipse($dot, $cx + $s*0.22, $cy + $s*0.06, $dotSize*0.8, $dotSize*0.8)

    # Body (dark line)
    $bodyW = [Math]::Max(2, $s*0.035)
    $bodyPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 90, 62, 40)), $bodyW
    $bodyPen.StartCap = 'Round'
    $bodyPen.EndCap = 'Round'
    $g.DrawLine($bodyPen, $cx, $cy - $s*0.36, $cx, $cy + $s*0.28)

    # Head
    $headR = [Math]::Max(2, $s*0.045)
    $head = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 90, 62, 40))
    $g.FillEllipse($head, $cx - $headR/2, $cy - $s*0.40 - $headR/2, $headR, $headR)

    # Antennae
    $antennaPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 90, 62, 40)), ([Math]::Max(1, $s*0.015))
    $g.DrawLine($antennaPen, $cx, $cy - $s*0.38, $cx - $s*0.06, $cy - $s*0.46)
    $g.DrawLine($antennaPen, $cx, $cy - $s*0.38, $cx + $s*0.06, $cy - $s*0.46)

    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "[OK] Created: $path ($size x $size, scale=$scale)"
}

$outDir = "C:\Users\lordabuy\Downloads\metamorfosis-pwa"
New-ButterflyIcon -size 192 -path "$outDir\icon-192.png" -scale 0.85
New-ButterflyIcon -size 512 -path "$outDir\icon-512.png" -scale 0.85
New-ButterflyIcon -size 512 -path "$outDir\icon-512-maskable.png" -scale 0.65
Write-Host "`nAll icons generated."
