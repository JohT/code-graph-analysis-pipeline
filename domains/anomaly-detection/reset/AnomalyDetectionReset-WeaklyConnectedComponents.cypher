// Reset all WeaklyConnectedComponent nodes and their relationships

  MATCH (component:WeaklyConnectedComponent)
   CALL {   WITH component
          DETACH DELETE component
        } IN TRANSACTIONS OF 1000 ROWS
 RETURN count(component) as numberOfDeletedComponents