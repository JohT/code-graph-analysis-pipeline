// Label build-in Java types

  MATCH (t:Type)
   WITH t
       ,CASE WHEN (t.fqn STARTS WITH 'java.') THEN true
             WHEN (t.fqn STARTS WITH 'com.sun.') THEN true
             WHEN (t.fqn STARTS WITH 'javax.accessibility') THEN true
             WHEN (t.fqn STARTS WITH 'javax.annotation.processing') THEN true
             WHEN (t.fqn STARTS WITH 'javax.crypto') THEN true
             WHEN (t.fqn STARTS WITH 'javax.lang.model') THEN true
             WHEN (t.fqn STARTS WITH 'javax.management') THEN true
             WHEN (t.fqn STARTS WITH 'javax.naming') THEN true
             WHEN (t.fqn STARTS WITH 'javax.net') THEN true
             WHEN (t.fqn STARTS WITH 'javax.print') THEN true
             WHEN (t.fqn STARTS WITH 'javax.rmi.ssl') THEN true
             WHEN (t.fqn STARTS WITH 'javax.script') THEN true
             WHEN (t.fqn STARTS WITH 'javax.security.') THEN true
             WHEN (t.fqn STARTS WITH 'javax.smartcardio') THEN true
             WHEN (t.fqn STARTS WITH 'javax.sound.') THEN true
             WHEN (t.fqn STARTS WITH 'javax.sql') THEN true
             WHEN (t.fqn STARTS WITH 'javax.swing') THEN true
             WHEN (t.fqn STARTS WITH 'javax.tools') THEN true
             WHEN (t.fqn STARTS WITH 'javax.transaction.xa') THEN true
             WHEN (t.fqn STARTS WITH 'javax.xml') THEN true
             WHEN (t.fqn STARTS WITH 'jdk.') THEN true
             WHEN (t.fqn STARTS WITH 'netscape.javascript') THEN true
             WHEN (t.fqn STARTS WITH 'org.ietf.jgss') THEN true
             WHEN (t.fqn STARTS WITH 'org.w3c.dom') THEN true
             WHEN (t.fqn STARTS WITH 'org.xml.sax') THEN true    
            ELSE false
        END AS isJavaType                                          
  WHERE isJavaType
    SET t:JavaType 
 RETURN labels(t), count(t) as numberOfJavaTypes