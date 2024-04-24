//Extract Custom Manifest Entries
MATCH (artifact:Artifact)-[:CONTAINS]->(manifest:Manifest)-[:DECLARES]->(section:ManifestSection)
OPTIONAL MATCH (section)-[:HAS]->(bundleName:ManifestEntry{name: 'Bundle-Name'})
OPTIONAL MATCH (section)-[:HAS]->(bundleVersion:ManifestEntry{name: 'Bundle-Version'})
//WHERE artifact.fileName CONTAINS 'messaging' 
RETURN artifact, bundleName.value, bundleVersion.value
 LIMIT 10