xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "text";




let $doc := doc("unicode.xml")
let $header := "unicode,mathvariant_unicode,mathvariant_type,length"
let $items :=
  for $c in $doc//character[surrogate] order by $c/surrogate/@mathvariant, $c/surrogate/@ref 
  let $unicode := $c/surrogate/@ref
  let $unicode_dec := $doc//character[@id=$unicode]/@dec
  let $mathvariant_unicode := $c/@dec
  let $bmp := $doc//character[@id=$c/bmp/@ref]/@dec
  let $mathvariant_type := $c/surrogate/@mathvariant
  return <item in="{xs:integer($unicode_dec)}"
  out="{xs:integer(($bmp,$mathvariant_unicode)[1])}"
  variant="{xs:string($mathvariant_type)}"
  len="1"/>
   

let $compressd := fold-left($items,(),function($seq,$new){
   let $last :=  $seq[last()]
   let $len := $last/@len
   let $unchanged := $new/@in = $last/@in+$len and
   $new/@out = $last/@out+$len and
   $new/@variant = $last/@variant
  return if ($unchanged) then (
    subsequence($seq, 1, count($seq) - 1), <item
  in="{$last/@in}" out="{$last/@out}" variant="{$last/@variant}" len="{$len+1}"/>)
   else 
   ($seq,$new)
})

let $rows := for $i in $compressd
return string-join((
    $i/@in,
    $i/@out,
    $i/@variant,
    $i/@len
  ), ",")

return string-join(($header,$rows), "&#10;")

