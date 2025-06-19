xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

let $doc := doc("unicode.xml")
let $header := "unicode,mathvariant_unicode,mathvariant_type"
let $rows :=
  for $c in $doc//character[surrogate] order by $c/surrogate/@mathvariant, $c/surrogate/@ref 
  let $unicode := $c/surrogate/@ref
  let $unicode_dec := $doc//character[@id=$unicode]/@dec
  let $mathvariant_unicode := $c/@dec
  let $bmp := $doc//character[@id=$c/bmp/@ref]/@dec
  let $mathvariant_type := $c/surrogate/@mathvariant
  let $row := string-join((
    $unicode_dec,
    ($bmp,$mathvariant_unicode)[1],
    $mathvariant_type
  ), ",")
  return $row

return string-join(($header, $rows), "&#10;")
