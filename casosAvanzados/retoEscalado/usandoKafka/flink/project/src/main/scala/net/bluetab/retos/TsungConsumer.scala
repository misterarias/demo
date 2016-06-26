package net.bluetab.retos

/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.apache.flink.api.java.utils.ParameterTool
import org.apache.flink.streaming.api.scala._
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer
import org.apache.flink.streaming.util.serialization.SimpleStringSchema
import org.slf4j.LoggerFactory
import org.slf4j.Logger

/**
  *
  * Consume from a Kafka topic called 'topic'
  * Usage:
  * {{{
  *   TsungConsumer --topic topic1 --bootstrap.servers localhost:9092 --zookeeper.connect localhost:2181 --group.id myGroup
  * }}}
  *
  */
object TsungConsumer {

  def main(args: Array[String]) {

    val parameterTool: ParameterTool = ParameterTool.fromArgs(args)
    val topicname: String = parameterTool.getRequired("topic")
    val env: StreamExecutionEnvironment =
      StreamExecutionEnvironment.getExecutionEnvironment


    try {
      val consumer = new FlinkKafkaConsumer[String](
        topicname,
        new SimpleStringSchema(),
        parameterTool.getProperties,
        FlinkKafkaConsumer.OffsetStore.FLINK_ZOOKEEPER,
        FlinkKafkaConsumer.FetcherType.LEGACY_LOW_LEVEL
      )

      val messageStream: DataStream[String] =
        env.addSource(consumer)

      messageStream.print()

      env.execute("Scala TsungConsumer")
    } catch {
      case e: Exception => e.printStackTrace()
    }
  }

}
