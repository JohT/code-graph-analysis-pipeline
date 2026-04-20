// Verify if CHANGED_TOGETHER_WITH properties from git are missing

MATCH (firstCodeFile)-[pairwiseChange:CHANGED_TOGETHER_WITH]-(secondCodeFile)
RETURN (pairwiseChange.updateCommitCount IS NULL)                       AS updateCommitCountMissing
      ,(pairwiseChange.updateCommitMinConfidence IS NULL)               AS updateCommitMinConfidenceMissing
      ,count(*)