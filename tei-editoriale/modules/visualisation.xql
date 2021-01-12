xquery version "3.1";
module namespace vis="http://localhost:8080/exist/apps/projet/visualisation";
declare namespace tei="http://www.tei-c.org/ns/1.0";
(:declare namespace functx = "http://www.functx.com"; :)
import module namespace config="http://localhost:8080/exist/apps/projet/config" at "config.xqm";
import module namespace fd="http://localhost:8080/exist/apps/projet/find" at "findDocument.xqm";
import module namespace functx="http://www.functx.com";
(:declare namespace request="http://exist-db.org/xquery/request";:)
declare function vis:present-docs($node as node(), $model as map(*)) as element(option)*{
     for $doc in collection($config:app-root || "/data")
     let $fileName := xs:string(util:document-name($doc))
     return 
        <p><a href="data/$fileName">{util:document-name($doc)}</a></p>
(:    NOT FINISHED!!!:)
};











