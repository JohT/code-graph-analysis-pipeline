//Calculate and set Abstractness
 MATCH (p:Package)
  WITH p
      ,toFloat(p.numberAbstractTypes) / (p.numberTypes + 1E-38)  AS abstractness
   SET p.abstractness = abstractness
RETURN p.fqn AS packageName, p.numberAbstractTypes, p.numberTypes, abstractness