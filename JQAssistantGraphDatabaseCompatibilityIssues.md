# jQAssistant Graph Database Compatibility Issues

## Neo4j v5

As it looks like, compatibility to Neo4j v5 is already in progress: [upgraded initial Neo4j queries to support 5.x](https://github.com/buschmais/extended-objects/commit/bd484e283f44a26c250cd80d5108516fa8ca98d0). It will be available with version 2.2 of [com.buschmais.xo - xo.impl](https://mvnrepository.com/artifact/com.buschmais.xo/xo.impl). Then it also needs to be updated in the upstream jQAssistant command line artifact.

### References

- https://neo4j.com/docs/upgrade-migration-guide/current/version-5/changelogs/procedures
- https://neo4j.com/docs/operations-manual/current/reference/procedures/#procedure_dbms_components
- https://github.com/buschmais/extended-objects/blob/0b91a5d55c9a76adba28ddccd6caba699eeaa1fc/neo4j/spi/src/main/java/com/buschmais/xo/neo4j/spi/AbstractNeo4jDatastoreSession.java#L66
- https://github.com/buschmais/extended-objects/commit/bd484e283f44a26c250cd80d5108516fa8ca98d0

### Stacktrace

```java
Exception in thread "main" com.buschmais.xo.api.XOException: Cannot execute statement 'CALL db.indexes() YIELD tokenNames AS labels, properties AS properties RETURN labels, properties', {}
        at com.buschmais.xo.neo4j.remote.impl.datastore.StatementExecutor.execute(StatementExecutor.java:51)
        at com.buschmais.xo.neo4j.remote.impl.datastore.RemoteCypherQuery.execute(RemoteCypherQuery.java:36)
        at com.buschmais.xo.neo4j.spi.AbstractNeo4jDatastoreSession.getIndexes(AbstractNeo4jDatastoreSession.java:70)
        at com.buschmais.xo.neo4j.spi.AbstractNeo4jDatastoreSession.getIndexes(AbstractNeo4jDatastoreSession.java:30)
        at com.buschmais.xo.neo4j.spi.AbstractNeo4jDatastore.lambda$init$2(AbstractNeo4jDatastore.java:40)
        at com.buschmais.xo.neo4j.spi.AbstractNeo4jDatastore.inTransaction(AbstractNeo4jDatastore.java:57)
        at com.buschmais.xo.neo4j.spi.AbstractNeo4jDatastore.init(AbstractNeo4jDatastore.java:40)
        at com.buschmais.xo.impl.XOManagerFactoryImpl.<init>(XOManagerFactoryImpl.java:57)
        at com.buschmais.xo.impl.bootstrap.XOBootstrapServiceImpl.createXOManagerFactory(XOBootstrapServiceImpl.java:41)
        at com.buschmais.xo.api.bootstrap.XO.createXOManagerFactory(XO.java:48)
        at com.buschmais.jqassistant.core.store.impl.AbstractGraphStore.start(AbstractGraphStore.java:66)
        at com.buschmais.jqassistant.commandline.task.AbstractStoreTask.withStore(AbstractStoreTask.java:69)
        at com.buschmais.jqassistant.commandline.task.AnalyzeTask.run(AnalyzeTask.java:65)
        at com.buschmais.jqassistant.commandline.Main.executeTask(Main.java:306)
        at com.buschmais.jqassistant.commandline.Main.executeTasks(Main.java:264)
        at com.buschmais.jqassistant.commandline.Main.interpretCommandLine(Main.java:247)
        at com.buschmais.jqassistant.commandline.Main.run(Main.java:93)
        at com.buschmais.jqassistant.commandline.Main.main(Main.java:64)
Caused by: org.neo4j.driver.exceptions.ClientException: There is no procedure with the name `db.indexes` registered for this database instance. Please ensure you've spelled the procedure name correctly and that the procedure is properly deployed.
        at org.neo4j.driver.internal.util.Futures.blockingGet(Futures.java:144)
        at org.neo4j.driver.internal.InternalTransaction.run(InternalTransaction.java:60)
        at org.neo4j.driver.internal.AbstractQueryRunner.run(AbstractQueryRunner.java:37)
        at org.neo4j.driver.internal.AbstractQueryRunner.run(AbstractQueryRunner.java:43)
        at com.buschmais.xo.neo4j.remote.impl.datastore.StatementExecutor.execute(StatementExecutor.java:49)
        ... 17 more
        Suppressed: org.neo4j.driver.internal.util.ErrorUtil$InternalExceptionCause
                at org.neo4j.driver.internal.util.ErrorUtil.newNeo4jError(ErrorUtil.java:99)
                at org.neo4j.driver.internal.async.inbound.InboundMessageDispatcher.handleFailureMessage(InboundMessageDispatcher.java:122)
                at org.neo4j.driver.internal.messaging.common.CommonMessageReader.unpackFailureMessage(CommonMessageReader.java:83)
                at org.neo4j.driver.internal.messaging.common.CommonMessageReader.read(CommonMessageReader.java:59)
                at org.neo4j.driver.internal.async.inbound.InboundMessageHandler.channelRead0(InboundMessageHandler.java:83)
                at org.neo4j.driver.internal.async.inbound.InboundMessageHandler.channelRead0(InboundMessageHandler.java:35)
                at org.neo4j.driver.internal.shaded.io.netty.channel.SimpleChannelInboundHandler.channelRead(SimpleChannelInboundHandler.java:99)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:379)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:365)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.fireChannelRead(AbstractChannelHandlerContext.java:357)
                at org.neo4j.driver.internal.shaded.io.netty.handler.codec.ByteToMessageDecoder.fireChannelRead(ByteToMessageDecoder.java:324)
                at org.neo4j.driver.internal.shaded.io.netty.handler.codec.ByteToMessageDecoder.channelRead(ByteToMessageDecoder.java:296)
                at org.neo4j.driver.internal.async.inbound.MessageDecoder.channelRead(MessageDecoder.java:47)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:379)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:365)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.fireChannelRead(AbstractChannelHandlerContext.java:357)
                at org.neo4j.driver.internal.shaded.io.netty.handler.codec.ByteToMessageDecoder.fireChannelRead(ByteToMessageDecoder.java:324)
                at org.neo4j.driver.internal.shaded.io.netty.handler.codec.ByteToMessageDecoder.fireChannelRead(ByteToMessageDecoder.java:311)
                at org.neo4j.driver.internal.shaded.io.netty.handler.codec.ByteToMessageDecoder.callDecode(ByteToMessageDecoder.java:432)
                at org.neo4j.driver.internal.shaded.io.netty.handler.codec.ByteToMessageDecoder.channelRead(ByteToMessageDecoder.java:276)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:379)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:365)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.fireChannelRead(AbstractChannelHandlerContext.java:357)
                at org.neo4j.driver.internal.shaded.io.netty.handler.timeout.IdleStateHandler.channelRead(IdleStateHandler.java:286)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:379)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:365)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.fireChannelRead(AbstractChannelHandlerContext.java:357)
                at org.neo4j.driver.internal.shaded.io.netty.channel.DefaultChannelPipeline$HeadContext.channelRead(DefaultChannelPipeline.java:1410)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:379)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:365)
                at org.neo4j.driver.internal.shaded.io.netty.channel.DefaultChannelPipeline.fireChannelRead(DefaultChannelPipeline.java:919)
                at org.neo4j.driver.internal.shaded.io.netty.channel.nio.AbstractNioByteChannel$NioByteUnsafe.read(AbstractNioByteChannel.java:166)
                at org.neo4j.driver.internal.shaded.io.netty.channel.nio.NioEventLoop.processSelectedKey(NioEventLoop.java:719)
                at org.neo4j.driver.internal.shaded.io.netty.channel.nio.NioEventLoop.processSelectedKeysOptimized(NioEventLoop.java:655)
                at org.neo4j.driver.internal.shaded.io.netty.channel.nio.NioEventLoop.processSelectedKeys(NioEventLoop.java:581)
                at org.neo4j.driver.internal.shaded.io.netty.channel.nio.NioEventLoop.run(NioEventLoop.java:493)
                at org.neo4j.driver.internal.shaded.io.netty.util.concurrent.SingleThreadEventExecutor$4.run(SingleThreadEventExecutor.java:986)
                at org.neo4j.driver.internal.shaded.io.netty.util.internal.ThreadExecutorMap$2.run(ThreadExecutorMap.java:74)
                at org.neo4j.driver.internal.shaded.io.netty.util.concurrent.FastThreadLocalRunnable.run(FastThreadLocalRunnable.java:30)
                at java.base/java.lang.Thread.run(Thread.java:833)
```

## Memgraph

The method [AbstractNeo4jDatastoreSession.getNeo4jVersion](https://github.com/buschmais/extended-objects/blob/0b91a5d55c9a76adba28ddccd6caba699eeaa1fc/neo4j/spi/src/main/java/com/buschmais/xo/neo4j/spi/AbstractNeo4jDatastoreSession.java#L50) uses the procedure `dbms.components()`.

This procedure is available in Neo4j v4, doesn't seem to be there in memgraph.

> List DBMS components and their versions.  
> dbms.components() :: (name :: STRING?, versions :: LIST? OF STRING?, edition :: STRING?)

### Stacktrace

```java
Exception in thread "main" com.buschmais.xo.api.XOException: Cannot execute statement 'CALL dbms.components() YIELD versions UNWIND versions AS version RETURN version', {}
        at com.buschmais.xo.neo4j.remote.impl.datastore.StatementExecutor.execute(StatementExecutor.java:51)
        at com.buschmais.xo.neo4j.remote.impl.datastore.RemoteCypherQuery.execute(RemoteCypherQuery.java:36)
        at com.buschmais.xo.neo4j.spi.AbstractNeo4jDatastoreSession.getNeo4jVersion(AbstractNeo4jDatastoreSession.java:51)
        at com.buschmais.xo.neo4j.spi.AbstractNeo4jDatastoreSession.getIndexes(AbstractNeo4jDatastoreSession.java:29)
        at com.buschmais.xo.neo4j.spi.AbstractNeo4jDatastore.lambda$init$2(AbstractNeo4jDatastore.java:40)
        at com.buschmais.xo.neo4j.spi.AbstractNeo4jDatastore.inTransaction(AbstractNeo4jDatastore.java:57)
        at com.buschmais.xo.neo4j.spi.AbstractNeo4jDatastore.init(AbstractNeo4jDatastore.java:40)
        at com.buschmais.xo.impl.XOManagerFactoryImpl.<init>(XOManagerFactoryImpl.java:57)
        at com.buschmais.xo.impl.bootstrap.XOBootstrapServiceImpl.createXOManagerFactory(XOBootstrapServiceImpl.java:41)
        at com.buschmais.xo.api.bootstrap.XO.createXOManagerFactory(XO.java:48)
        at com.buschmais.jqassistant.core.store.impl.AbstractGraphStore.start(AbstractGraphStore.java:66)
        at com.buschmais.jqassistant.commandline.task.AbstractStoreTask.withStore(AbstractStoreTask.java:69)
        at com.buschmais.jqassistant.commandline.task.ScanTask.run(ScanTask.java:78)
        at com.buschmais.jqassistant.commandline.Main.executeTask(Main.java:306)
        at com.buschmais.jqassistant.commandline.Main.executeTasks(Main.java:264)
        at com.buschmais.jqassistant.commandline.Main.interpretCommandLine(Main.java:247)
        at com.buschmais.jqassistant.commandline.Main.run(Main.java:93)
        at com.buschmais.jqassistant.commandline.Main.main(Main.java:64)
Caused by: org.neo4j.driver.exceptions.ClientException: There is no procedure named 'dbms.components'.
        at org.neo4j.driver.internal.util.Futures.blockingGet(Futures.java:144)
        at org.neo4j.driver.internal.InternalTransaction.run(InternalTransaction.java:60)
        at org.neo4j.driver.internal.AbstractQueryRunner.run(AbstractQueryRunner.java:37)
        at org.neo4j.driver.internal.AbstractQueryRunner.run(AbstractQueryRunner.java:43)
        at com.buschmais.xo.neo4j.remote.impl.datastore.StatementExecutor.execute(StatementExecutor.java:49)
        ... 17 more
        Suppressed: org.neo4j.driver.internal.util.ErrorUtil$InternalExceptionCause
                at org.neo4j.driver.internal.util.ErrorUtil.newNeo4jError(ErrorUtil.java:99)
                at org.neo4j.driver.internal.async.inbound.InboundMessageDispatcher.handleFailureMessage(InboundMessageDispatcher.java:122)
                at org.neo4j.driver.internal.messaging.common.CommonMessageReader.unpackFailureMessage(CommonMessageReader.java:83)
                at org.neo4j.driver.internal.messaging.common.CommonMessageReader.read(CommonMessageReader.java:59)
                at org.neo4j.driver.internal.async.inbound.InboundMessageHandler.channelRead0(InboundMessageHandler.java:83)
                at org.neo4j.driver.internal.async.inbound.InboundMessageHandler.channelRead0(InboundMessageHandler.java:35)
                at org.neo4j.driver.internal.shaded.io.netty.channel.SimpleChannelInboundHandler.channelRead(SimpleChannelInboundHandler.java:99)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:379)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:365)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.fireChannelRead(AbstractChannelHandlerContext.java:357)
                at org.neo4j.driver.internal.shaded.io.netty.handler.codec.ByteToMessageDecoder.fireChannelRead(ByteToMessageDecoder.java:324)
                at org.neo4j.driver.internal.shaded.io.netty.handler.codec.ByteToMessageDecoder.channelRead(ByteToMessageDecoder.java:296)
                at org.neo4j.driver.internal.async.inbound.MessageDecoder.channelRead(MessageDecoder.java:47)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:379)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:365)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.fireChannelRead(AbstractChannelHandlerContext.java:357)
                at org.neo4j.driver.internal.shaded.io.netty.handler.codec.ByteToMessageDecoder.fireChannelRead(ByteToMessageDecoder.java:324)
                at org.neo4j.driver.internal.shaded.io.netty.handler.codec.ByteToMessageDecoder.fireChannelRead(ByteToMessageDecoder.java:311)
                at org.neo4j.driver.internal.shaded.io.netty.handler.codec.ByteToMessageDecoder.callDecode(ByteToMessageDecoder.java:432)
                at org.neo4j.driver.internal.shaded.io.netty.handler.codec.ByteToMessageDecoder.channelRead(ByteToMessageDecoder.java:276)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:379)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:365)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.fireChannelRead(AbstractChannelHandlerContext.java:357)
                at org.neo4j.driver.internal.shaded.io.netty.channel.DefaultChannelPipeline$HeadContext.channelRead(DefaultChannelPipeline.java:1410)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:379)
                at org.neo4j.driver.internal.shaded.io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:365)
                at org.neo4j.driver.internal.shaded.io.netty.channel.DefaultChannelPipeline.fireChannelRead(DefaultChannelPipeline.java:919)
                at org.neo4j.driver.internal.shaded.io.netty.channel.nio.AbstractNioByteChannel$NioByteUnsafe.read(AbstractNioByteChannel.java:166)
                at org.neo4j.driver.internal.shaded.io.netty.channel.nio.NioEventLoop.processSelectedKey(NioEventLoop.java:719)
                at org.neo4j.driver.internal.shaded.io.netty.channel.nio.NioEventLoop.processSelectedKeysOptimized(NioEventLoop.java:655)
                at org.neo4j.driver.internal.shaded.io.netty.channel.nio.NioEventLoop.processSelectedKeys(NioEventLoop.java:581)
                at org.neo4j.driver.internal.shaded.io.netty.channel.nio.NioEventLoop.run(NioEventLoop.java:493)
                at org.neo4j.driver.internal.shaded.io.netty.util.concurrent.SingleThreadEventExecutor$4.run(SingleThreadEventExecutor.java:986)
                at org.neo4j.driver.internal.shaded.io.netty.util.internal.ThreadExecutorMap$2.run(ThreadExecutorMap.java:74)
                at org.neo4j.driver.internal.shaded.io.netty.util.concurrent.FastThreadLocalRunnable.run(FastThreadLocalRunnable.java:30)
                at java.base/java.lang.Thread.run(Thread.java:829)
```