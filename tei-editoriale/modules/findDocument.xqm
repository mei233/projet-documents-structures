xquery version "3.1";

module namespace fd="http://localhost:8080/exist/apps/projet/find";
declare namespace tei="http://www.tei-c.org/ns/1.0";
import module namespace config="http://localhost:8080/exist/apps/projet/config" at "config.xqm";
import module namespace functx="http://www.functx.com";
import module namespace kwic="http://exist-db.org/xquery/kwic";

(:fd:requete-mot helper function for finding a word/words in texte:)
declare function fd:requete-mot ($queryMot as xs:string?,$optionAuteur as xs:string?, $optionTitre as xs:string?, $yearStart as xs:int?, $yearEnd as xs:int?, $length as xs:int?){
        if ($optionAuteur != 'tous') then
            let $filesFound := fd:author-year($yearStart, $yearEnd, $optionAuteur)
            for $file2 in $filesFound, $file1 in collection($config:app-root || "/data")
            where (xs:string(util:document-name($file1)) eq xs:string($file2))
            return
                if (contains($file1//*/string(), $queryMot)) then
                    let $res :=
                        for $node in $file1//tei:p[ft:query(.,$queryMot)]
                        let $sum := kwic:summarize($node, <config width="{$length}"/>)
                        let $hit-count := count($sum/span[@class="hi"])
                        return
                            <div>
                                <c>{$hit-count}</c>
                                <p>{$sum}</p>
                                </div>
                    return 
       <p>** <b>{sum($res/c)}</b> résultats de la requête <b>{$queryMot}</b> dans le fichier <b>{util:document-name($file1)}</b> <br/> {$res/p}</p>
                else
                    <p>Aucun résultat de la requête <b>{$queryMot}</b> n'a été trouvé dans le fichier <b>{util:document-name($file1)}</b></p>
        else if ($optionTitre != 'tous') then
            let $filesFound := fd:titre($optionTitre)
            for $file2 in $filesFound
            for $file1 in collection($config:app-root || "/data")
            where (xs:string(util:document-name($file1)) eq xs:string($file2))
            return 
                if (contains($file1//*/string(), $queryMot)) then
                    let $res :=
                        for $node in $file1//tei:p[ft:query(.,$queryMot)]
                        let $sum := kwic:summarize($node, <config width="{$length}"/>)
                        let $hit-count := count($sum/span[@class="hi"])
                        return
                            <div>
                                <c>{$hit-count}</c>
                                <p>{$sum}</p>
                                </div>
                    return
         <p>** <b>{sum($res/c)}</b> résultats de la requête <b>{$queryMot}</b> dans le fichier <b>{util:document-name($file1)}</b> <br/> {$res/p}</p>
                else
                    <p>Aucun résultat de la requête <b>{$queryMot}</b> n'a été trouvé dans le fichier <b>{util:document-name($file1)}</b></p>
        else if ($yearStart or $yearEnd) then
            let $filesFound := fd:year($yearStart, $yearEnd)
            for $file2 in $filesFound, $file1 in collection($config:app-root || "/data")
            where (xs:string(util:document-name($file1)) eq xs:string($file2))
            return 
                if (contains($file1//*/string(), $queryMot)) then
                    let $res :=
                        for $node in $file1//tei:p[ft:query(.,$queryMot)]
                        let $sum := kwic:summarize($node, <config width="{$length}"/>)
                        let $hit-count := count($sum/span[@class="hi"])
                        return
                            <div>
                                <c>{$hit-count}</c>
                                <p>{$sum}</p>
                                </div>
                    return
                            
         <p>** <b>{sum($res/c)}</b> résultats de la requête <b>{$queryMot}</b> dans le fichier <b>{util:document-name($file1)}</b> <br/> {$res/p}</p>
                else
                    <p>Aucun résultat de la requête <b>{$queryMot}</b> n'a été trouvé dans le fichier <b>{util:document-name($file1)}</b></p>
        else
            for $file1 in collection($config:app-root || "/data")
            return
            if (contains($file1//*/string(), $queryMot)) then
                  let $res :=
                        for $node in $file1//tei:p[ft:query(.,$queryMot)]
                        let $sum := kwic:summarize($node, <config width="{$length}"/>)
                        let $hit-count := count($sum/span[@class="hi"])
                        return
                            <div>
                                <c>{$hit-count}</c>
                                <p>{$sum}</p>
                                </div>
                    return
         <p>** <b>{sum($res/c)}</b> résultats de la requête <b>{$queryMot}</b> dans le fichier <b>{util:document-name($file1)}</b> <br/> {$res/p}</p>
                else
                    <p>Aucun résultat de la requête <b>{$queryMot}</b> n'a été trouvé dans le fichier <b>{util:document-name($file1)}</b></p>
            
};



declare function fd:prestraitment-mot-precise($word as xs:string) as xs:string{
    let $word := normalize-space($word)
    return concat(' ', $word, ' ')
};


declare function fd:prestraitment-mot-floue($word as xs:string) as xs:string{
    let $word := normalize-space($word)
    return $word
};





declare function fd:find-number-documents($authorFind as xs:string) as xs:int{
    let $c := count(collection($config:app-root || "/data")//tei:author[. eq $authorFind])
    return $c

};


(:fd:year for finding the docs according to year:)
declare function fd:year($yearStart as xs:int?, $yearEnd as xs:int?) {
    if ($yearStart and $yearEnd) then
        for $doc in collection($config:app-root || "/data")
        let $fileYear := $doc//tei:publicationStmt/tei:date/string()
        let $year := tokenize($fileYear,'/')[position() =last()]
        return 
        if (xs:int($year) >= $yearStart and xs:int($year) <= $yearEnd) then
            util:document-name($doc)
        else()
    else if ($yearStart) then
        for $doc in collection($config:app-root || "/data")
        let $fileYear := $doc//tei:publicationStmt/tei:date
        let $year := tokenize($fileYear,'/')[position() =last()]
        return
        if (xs:int($year) = $yearStart) then
            util:document-name($doc)
        else()
        
    else if ($yearEnd) then
        for $doc in collection($config:app-root || "/data")
        let $fileYear := $doc//tei:publicationStmt/tei:date
        let $year := tokenize($fileYear,'/')[position() =last()]
(:        let $files := '':)
        return
        if (xs:int($year) = $yearEnd) then
            util:document-name($doc)
        else()
    else 
       ()
};


(:fd:author-year for finding the docs according to author and then year:)
declare function fd:author-year($yearStart as xs:int?, $yearEnd as xs:int?, $optionAuteur as xs:string){
    if ($yearStart and $yearEnd) then
        for $doc in collection($config:app-root || "/data")
        let $author := $doc//tei:author
        where ($optionAuteur eq $author)
        let $fileYear := $doc//tei:publicationStmt/tei:date/string()
        let $year := tokenize($fileYear,'/')[position() =last()]
        return
        if (xs:int($year) >= $yearStart and xs:int($year) <= $yearEnd) then
            util:document-name($doc)
        else
            <p>Pas de résultat.</p>
    else if ($yearStart) then
        for $doc in collection($config:app-root || "/data")
        let $author := $doc//tei:author
        where ($optionAuteur eq $author)
        let $fileYear := $doc//tei:publicationStmt/tei:date
        let $year := tokenize($fileYear,'/')[position() =last()]
        return
        if (xs:int($year) = $yearStart) then
            util:document-name($doc)
        else
            <p>Pas de résultat.</p>
        
    else if ($yearEnd) then
        for $doc in collection($config:app-root || "/data")
        let $author := $doc//tei:author/string()
        where ($optionAuteur eq $author)
        let $fileYear := $doc//tei:publicationStmt/tei:date
        let $year := tokenize($fileYear,'/')[position() =last()]
        return
        if (xs:int($year) = $yearEnd) then
            util:document-name($doc)
        else
            <p>Pas de résultat.</p>
    else 
        for $doc in collection($config:app-root || "/data")
        let $author := $doc//tei:author
        return 
        if ($optionAuteur eq $author) then
            util:document-name($doc)
        else 
            ()
    
} ;


(:fd:titre for finding the docs according to only the title:)
declare function fd:titre( $optionTitre as xs:string){
    for $doc in collection($config:app-root || "/data")
    let $titre := $doc//tei:titleStmt/tei:title/string()
    return 
    if ($optionTitre eq $titre) then
        util:document-name($doc)
    else ()
    
};


declare function fd:find-number-document($queryMot as xs:string, $file as xs:string){
    let $queryMot := concat(' ', $queryMot, ' ')
    let $count := count(collection($config:app-root || "/data")//*/text()[contains(.,$queryMot)])
    let $matches := functx:number-of-matches(doc($file)//*/text(),$queryMot)
    return 
        if ($matches != 0) then
        <div>
        <p>La requête a rétourné "{$matches}" résultats dans le fichier {util:document-name($file)}. </p>{
        for $node in $file//*
        where contains($node/text(), $queryMot)
        let $before := substring-before($node/string(), $queryMot)
        let $after := substring-after($node/string(), $queryMot)
        return <p>{$before,<b>{$queryMot}</b>,$after}</p>}
        
        </div>
    else
        ()
    
(:    return $count:)
};
