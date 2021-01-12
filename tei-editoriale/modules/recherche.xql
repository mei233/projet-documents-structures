xquery version "3.1";
module namespace rch="http://localhost:8080/exist/apps/projet/recherche";
declare namespace tei="http://www.tei-c.org/ns/1.0";
(:declare namespace functx = "http://www.functx.com"; :)
import module namespace config="http://localhost:8080/exist/apps/projet/config" at "config.xqm";
import module namespace fd="http://localhost:8080/exist/apps/projet/find" at "findDocument.xqm";
import module namespace functx="http://www.functx.com";
(:lucene:)
import module namespace kwic="http://exist-db.org/xquery/kwic";
declare namespace request="http://exist-db.org/xquery/request";


(:rch:present-author : helper fonction pour sélectionner un auteur du document :)
declare function rch:present-author($node as node(), $model as map(*)) as element(option)*{
     for $doc in collection($config:app-root || "/data")
     let $author := $doc//tei:author
     return <option value="{$author/text()}">{$author/text()}</option>
};

(:rch:present-titres : helper fonction pour sélectionner un titre du document :)
declare function rch:present-titres($node as node(), $model as map(*)) as element(option)*{
     for $doc in collection($config:app-root || "/data")
     let $titre := $doc//tei:titleStmt/tei:title
     return <option value="{$titre/text()}">{$titre/text()}</option>
};

(:rch:requete-mot-document for selecting condition and then find word/words:)
declare function rch:requete-mot-document ($node as node(), $model as map(*), $queryMot as xs:string?,$optionAuteur as xs:string?, $optionTitre as xs:string?, $yearStart as xs:int?, $yearEnd as xs:int?, $length as xs:int?){
    if ($queryMot != '') then
        if ($length) then 
            fd:requete-mot($queryMot,$optionAuteur,$optionTitre,$yearStart,$yearEnd,$length)
        else 
             fd:requete-mot($queryMot,$optionAuteur,$optionTitre,$yearStart,$yearEnd,40)
    else
        if ($optionAuteur != 'tous') then
            let $res := fd:author-year($yearStart, $yearEnd, $optionAuteur)
            return
              <p>{$res}</p>
        else if ($optionTitre != 'tous') then
            let $res := fd:titre( $optionTitre)
            return
              <p>{$res}</p>
        else if ($yearStart or $yearEnd) then
            let $res := fd:year($yearStart, $yearEnd)
            return
              <p>{$res}</p>
        else
            ()

};



declare function rch:filtrer($node as node(), $model as map(*), $optionAuteur as xs:string?, $optionTitre as xs:string?, $yearStart as xs:int?, $yearEnd as xs:int?) as element(option)*{
    if ($optionAuteur != 'tous') then
        <div><p>test1{$optionAuteur}</p>{fd:author-year($yearStart, $yearEnd, $optionAuteur)}</div>
        
    else if ($optionTitre != 'tous') then
        fd:titre( $optionTitre)
    else if ($yearStart or $yearEnd) then
        let $res := fd:year($yearStart, $yearEnd)
        return
          <p>{$res}</p>
    else
        ()
};

(:rch:requete-fichierXML : pour Trouver le nom du document
 :entrer: un nom et/ou un tire pour rechercher le nom du fichier xml :)
declare function rch:requete-fichierXML($node as node(), $model as map(*), $queryAuteur as xs:string?, $queryTitre as xs:string? ) as element(p)*{
    if ($queryAuteur and $queryTitre ) then
        for $doc in collection($config:app-root || "/data")
        let $title := $doc//tei:titleStmt/tei:title
        let $auteur := $doc//tei:author
        where ((lower-case($title) eq lower-case($queryTitre)) and (lower-case($auteur) eq lower-case($queryAuteur)))
        return <p>{util:document-name($doc)}</p>
    else if ($queryTitre) then 
        for $doc in collection($config:app-root || "/data")
        let $title := $doc//tei:titleStmt/tei:title
        let $res:= lower-case($title)
        where ($res eq lower-case($queryTitre))
        return <p>{util:document-name($doc)}</p>
    else if ($queryAuteur) then 
        for $doc in collection($config:app-root || "/data")
        let $auteur := $doc//tei:author
        where (lower-case($auteur) eq lower-case($queryAuteur))
        return <p>{util:document-name($doc)}</p>
    
    else ()
};

(:rch:requete-infos for helping find the informations of a certion doc:)
declare function rch:requete-infos($node as node(), $model as map(*), $queryDoc as xs:string?,$case as xs:boolean?) as element(div)*{
    if ($queryDoc) then
         if ($case = 'sensitive') then
            for $doc in collection($config:app-root || "/data")
            let $fileName := util:document-name($doc)
            where (xs:string($fileName) eq $queryDoc)
            return <div>
                <p>Nom du fichier : {$fileName}</p>
                <p>Titre : {$doc//tei:titleStmt/tei:title/text()}</p>
                <p>Auteur : {$doc//tei:author/text()}</p>
                <p>Date de Publication : {$doc//tei:publicationStmt/tei:date/text()}</p>
                <p>Date de Sortie : {$doc//tei:sourceDesc/tei:bibl/tei:date/text()}</p>
                <p>Bibliographe: <a href="{$doc//tei:sourceDesc/tei:bibl/tei:bibl/text()}" target="_blank">{$doc//tei:sourceDesc/tei:bibl/tei:bibl/text()}</a></p>
                </div>
        else
            for $doc in collection($config:app-root || "/data")
            let $fileName := util:document-name($doc)
            where (lower-case($fileName) eq lower-case($queryDoc))
            return <div>
                <p>Nom du fichier : {$fileName}</p>
                <p>Titre : {$doc//tei:titleStmt/tei:title/text()}</p>
                <p>Auteur : {$doc//tei:author/text()}</p>
                <p>Date de Publication : {$doc//tei:publicationStmt/tei:date/text()}</p>
                <p>Date de Sortie : {$doc//tei:sourceDesc/tei:bibl/tei:date/text()}</p>
                <p>Bibliographe: <a href="{$doc//tei:sourceDesc/tei:bibl/tei:bibl/text()}" target="_blank">{$doc//tei:sourceDesc/tei:bibl/tei:bibl/text()}</a></p>
                </div>
    else()

};




