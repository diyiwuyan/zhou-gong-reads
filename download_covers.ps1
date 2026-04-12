$covers = @(
  @(1,  "thinking-fast-slow.jpg",      "https://covers.openlibrary.org/b/isbn/9780374533557-L.jpg"),
  @(2,  "poor-charlies-almanack.jpg",  "https://covers.openlibrary.org/b/isbn/9781578645015-L.jpg"),
  @(3,  "black-swan.jpg",              "https://covers.openlibrary.org/b/isbn/9781400063512-L.jpg"),
  @(4,  "principles.jpg",              "https://covers.openlibrary.org/b/isbn/9781501124020-L.jpg"),
  @(5,  "peak.jpg",                    "https://covers.openlibrary.org/b/isbn/9780544456235-L.jpg"),
  @(6,  "flow.jpg",                    "https://covers.openlibrary.org/b/isbn/9780061339202-L.jpg"),
  @(7,  "nonviolent-communication.jpg","https://covers.openlibrary.org/b/isbn/9781892005038-L.jpg"),
  @(8,  "influence.jpg",               "https://covers.openlibrary.org/b/isbn/9780061241895-L.jpg"),
  @(9,  "power-of-habit.jpg",          "https://covers.openlibrary.org/b/isbn/9780812981605-L.jpg"),
  @(10, "deep-work.jpg",               "https://covers.openlibrary.org/b/isbn/9781455586691-L.jpg"),
  @(11, "almanack-naval.jpg",          "https://covers.openlibrary.org/b/isbn/9781544514215-L.jpg"),
  @(12, "courage-to-be-disliked.jpg",  "https://covers.openlibrary.org/b/isbn/9781501197277-L.jpg"),
  @(13, "mans-search-for-meaning.jpg", "https://covers.openlibrary.org/b/isbn/9780807014295-L.jpg"),
  @(14, "power-of-now.jpg",            "https://covers.openlibrary.org/b/isbn/9781577314806-L.jpg"),
  @(15, "willpower-instinct.jpg",      "https://covers.openlibrary.org/b/isbn/9781583334386-L.jpg"),
  @(16, "mindset.jpg",                 "https://covers.openlibrary.org/b/isbn/9780345472328-L.jpg"),
  @(17, "rich-dad-poor-dad.jpg",       "https://covers.openlibrary.org/b/isbn/9781612680194-L.jpg"),
  @(18, "intelligent-investor.jpg",    "https://covers.openlibrary.org/b/isbn/9780060555665-L.jpg"),
  @(19, "retail-philosophy.jpg",       "https://covers.openlibrary.org/b/isbn/9784478017036-L.jpg"),
  @(20, "zero-to-one.jpg",             "https://covers.openlibrary.org/b/isbn/9780804139021-L.jpg"),
  @(21, "hard-thing.jpg",              "https://covers.openlibrary.org/b/isbn/9780062273208-L.jpg"),
  @(22, "lean-startup.jpg",            "https://covers.openlibrary.org/b/isbn/9780307887894-L.jpg"),
  @(23, "good-strategy.jpg",           "https://covers.openlibrary.org/b/isbn/9780307886231-L.jpg"),
  @(24, "built-to-last.jpg",           "https://covers.openlibrary.org/b/isbn/9780060516406-L.jpg"),
  @(25, "sapiens.jpg",                 "https://covers.openlibrary.org/b/isbn/9780062316097-L.jpg"),
  @(26, "homo-deus.jpg",               "https://covers.openlibrary.org/b/isbn/9780771038686-L.jpg"),
  @(27, "guns-germs-steel.jpg",        "https://covers.openlibrary.org/b/isbn/9780393317558-L.jpg"),
  @(28, "selfish-gene.jpg",            "https://covers.openlibrary.org/b/isbn/9780198788607-L.jpg"),
  @(29, "brief-history-of-time.jpg",   "https://covers.openlibrary.org/b/isbn/9780553380163-L.jpg"),
  @(30, "godel-escher-bach.jpg",       "https://covers.openlibrary.org/b/isbn/9780465026562-L.jpg"),
  @(31, "sophies-world.jpg",           "https://covers.openlibrary.org/b/isbn/9780374530716-L.jpg"),
  @(32, "meditations.jpg",             "https://covers.openlibrary.org/b/isbn/9780140449334-L.jpg"),
  @(33, "tao-te-ching.jpg",            "https://covers.openlibrary.org/b/isbn/9780140441314-L.jpg"),
  @(34, "analects.jpg",                "https://covers.openlibrary.org/b/isbn/9780140443486-L.jpg"),
  @(35, "republic.jpg",                "https://covers.openlibrary.org/b/isbn/9780140455113-L.jpg"),
  @(36, "nicomachean-ethics.jpg",      "https://covers.openlibrary.org/b/isbn/9780140449495-L.jpg"),
  @(37, "social-contract.jpg",         "https://covers.openlibrary.org/b/isbn/9780140442014-L.jpg"),
  @(38, "wealth-of-nations.jpg",       "https://covers.openlibrary.org/b/isbn/9780140432084-L.jpg"),
  @(39, "das-kapital.jpg",             "https://covers.openlibrary.org/b/isbn/9780140445688-L.jpg"),
  @(40, "the-crowd.jpg",               "https://covers.openlibrary.org/b/isbn/9780140187861-L.jpg"),
  @(41, "fifth-discipline.jpg",        "https://covers.openlibrary.org/b/isbn/9780385517256-L.jpg"),
  @(42, "7-habits.jpg",                "https://covers.openlibrary.org/b/isbn/9780743269513-L.jpg"),
  @(43, "effective-executive.jpg",     "https://covers.openlibrary.org/b/isbn/9780062574343-L.jpg"),
  @(44, "art-of-war.jpg",              "https://covers.openlibrary.org/b/isbn/9781590302255-L.jpg"),
  @(45, "antifragile.jpg",             "https://covers.openlibrary.org/b/isbn/9780812979688-L.jpg"),
  @(46, "thinking-in-systems.jpg",     "https://covers.openlibrary.org/b/isbn/9781603580557-L.jpg"),
  @(47, "singularity-is-near.jpg",     "https://covers.openlibrary.org/b/isbn/9780670033843-L.jpg"),
  @(48, "what-is-life.jpg",            "https://covers.openlibrary.org/b/isbn/9781107604667-L.jpg")
)

$outDir = "assets\covers"
$ok = 0; $fail = 0; $failIds = @()

foreach ($item in $covers) {
  $id = $item[0]; $filename = $item[1]; $url = $item[2]
  $dest = Join-Path $outDir $filename
  try {
    Invoke-WebRequest -Uri $url -OutFile $dest -TimeoutSec 20 -UseBasicParsing | Out-Null
    $size = (Get-Item $dest).Length
    if ($size -lt 2000) {
      Write-Host "[$id] $filename - SKIP (too small: $size)"
      Remove-Item $dest -ErrorAction SilentlyContinue
      $fail++; $failIds += $id
    } else {
      Write-Host "[$id] $filename - OK ($size)"
      $ok++
    }
  } catch {
    Write-Host "[$id] $filename - FAIL"
    $fail++; $failIds += $id
  }
  Start-Sleep -Milliseconds 300
}

Write-Host ""
Write-Host "Done: OK=$ok FAIL=$fail"
if ($failIds.Count -gt 0) { Write-Host "Failed IDs: $($failIds -join ',')" }