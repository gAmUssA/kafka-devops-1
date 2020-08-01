#!/bin/bash

set -a

STARTUP_DELAY=${STARTUP_DELAY:-0}
CONFIG_FILE=${CONFIG_FILE:-"/etc/kafka/kafka.properties"}

BOOTSTRAP_SERVERS=$(grep "bootstrap.servers" $CONFIG_FILE | cut -d= -f2)
SECURITY_PROTOCOL=$(grep "security.protocol" $CONFIG_FILE | cut -d= -f2)
SASL_JAAS_CONFIG=$(grep "sasl.jaas.config" $CONFIG_FILE | cut -d= -f2-)
SSL_ENDPOINT_IDENTIFICATION_ALGORITHM=$(grep "ssl.endpoint.identification.algorithm" $CONFIG_FILE | cut -d= -f2)
SASL_MECHANISM=$(grep "sasl.mechanism" $CONFIG_FILE | cut -d= -f2)
SCHEMA_REGISTRY_URL=$(grep "schema.registry.url" $CONFIG_FILE | cut -d= -f2)
BASIC_AUTH_CREDENTIALS_SOURCE=$(grep "basic.auth.credentials.source" $CONFIG_FILE | cut -d= -f2)
SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO=$(grep "schema.registry.basic.auth.user.info" $CONFIG_FILE | cut -d= -f2)
REPLICATION_FACTOR=$(grep "replication.factor" $CONFIG_FILE | cut -d= -f2)

CONNECT_REST_ADVERTISED_HOST_NAME=$(hostname -I)

CONNECT_BOOTSTRAP_SERVERS=${CONNECT_BOOTSTRAP_SERVERS:-$BOOTSTRAP_SERVERS}
CONNECT_GROUP_ID=${CONNECT_GROUP_ID:="kafka-devops-connect"}
CONNECT_REST_PORT=${CONNECT_REST_PORT:="8083"}
CONNECT_SECURITY_PROTOCOL=${CONNECT_SECURITY_PROTOCOL:-$SECURITY_PROTOCOL}
CONNECT_SASL_MECHANISM=${CONNECT_SASL_MECHANISM:=$SASL_MECHANISM}
CONNECT_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM=${CONNECT_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM:-$SSL_ENDPOINT_IDENTIFICATION_ALGORITHM}
CONNECT_SASL_JAAS_CONFIG=${CONNECT_SASL_JAAS_CONFIG:-$SASL_JAAS_CONFIG}

CONNECT_CONFIG_STORAGE_TOPIC=${CONNECT_CONFIG_STORAGE_TOPIC:-"connect-configs"}
CONNECT_OFFSET_STORAGE_TOPIC=${CONNECT_OFFSET_STORAGE_TOPIC:-"connect-offsets"}
CONNECT_STATUS_STORAGE_TOPIC=${CONNECT_STATUS_STORAGE_TOPIC:-"connect-statuses"}

CONNECT_REPLICATION_FACTOR=${CONNECT_REPLICATION_FACTOR:-$REPLICATION_FACTOR}
CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR=${CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR:-$REPLICATION_FACTOR}
CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR=${CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR:-$REPLICATION_FACTOR}
CONNECT_STATUS_STORAGE_REPLICATION_FACTOR=${CONNECT_STATUS_STORAGE_REPLICATION_FACTOR:-$REPLICATION_FACTOR}

CONNECT_KEY_CONVERTER=${CONNECT_KEY_CONVERTER:-"io.confluent.connect.avro.AvroConverter"}
CONNECT_KEY_CONVERTER_SCHEMA_REGISTRY_URL=${CONNECT_KEY_CONVERTER_SCHEMA_REGISTRY_URL:-$SCHEMA_REGISTRY_URL}
CONNECT_KEY_CONVERTER_BASIC_AUTH_CREDENTIALS_SOURCE=${CONNECT_KEY_CONVERTER_BASIC_AUTH_CREDENTIALS_SOURCE:-$BASIC_AUTH_CREDENTIALS_SOURCE}
CONNECT_KEY_CONVERTER_SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO=${CONNECT_KEY_CONVERTER_SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO:-$SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO}
CONNECT_VALUE_CONVERTER=${CONNECT_VALUE_CONVERTER:-"io.confluent.connect.avro.AvroConverter"}
CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL=${CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL:-$SCHEMA_REGISTRY_URL}
CONNECT_VALUE_CONVERTER_BASIC_AUTH_CREDENTIALS_SOURCE=${CONNECT_VALUE_CONVERTER_BASIC_AUTH_CREDENTIALS_SOURCE:-$BASIC_AUTH_CREDENTIALS_SOURCE}
CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO=${CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO:-$SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO}

CONNECT_INTERNAL_KEY_CONVERTER=${CONNECT_INTERNAL_KEY_CONVERTER:-"org.apache.kafka.connect.json.JsonConverter"}
CONNECT_INTERNAL_VALUE_CONVERTER=${CONNECT_INTERNAL_VALUE_CONVERTER:-"org.apache.kafka.connect.json.JsonConverter"}

CLASSPATH=${CLASSPATH:-"/usr/share/java/monitoring-interceptors/monitoring-interceptors-5.5.1.jar"}
CONNECT_PLUGIN_PATH=${CONNECT_PLUGIN_PATH:-'/usr/share/java,/usr/share/confluent-hub-components/,/connectors/'}

CONNECT_PRODUCER_SECURITY_PROTOCOL=${CONNECT_PRODUCER_SECURITY_PROTOCOL:-$SECURITY_PROTOCOL}
CONNECT_PRODUCER_SASL_JAAS_CONFIG=${CONNECT_PRODUCER_SASL_JAAS_CONFIG:-$SASL_JAAS_CONFIG}
CONNECT_PRODUCER_SASL_MECHANISM=${CONNECT_PRODUCER_SASL_MECHANISM:-$SASL_MECHANISM}
CONNECT_PRODUCER_INTERCEPTOR_CLASSES=${CONNECT_PRODUCER_INTERCEPTOR_CLASSES:-"io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor"}
CONNECT_PRODUCER_CONFLUENT_MONITORING_INTERCEPTOR_BOOTSTRAP_SERVERS=${CONNECT_PRODUCER_CONFLUENT_MONITORING_INTERCEPTOR_BOOTSTRAP_SERVERS:-$BOOTSTRAP_SERVERS}
CONNECT_PRODUCER_CONFLUENT_MONITORING_INTERCEPTOR_SECURITY_PROTOCOL=${CONNECT_PRODUCER_CONFLUENT_MONITORING_INTERCEPTOR_SECURITY_PROTOCOL:-$SECURITY_PROTOCOL}
CONNECT_PRODUCER_CONFLUENT_MONITORING_INTERCEPTOR_SASL_JAAS_CONFIG=${CONNECT_PRODUCER_CONFLUENT_MONITORING_INTERCEPTOR_SASL_JAAS_CONFIG:-$SASL_JAAS_CONFIG}
CONNECT_PRODUCER_CONFLUENT_MONITORING_INTERCEPTOR_SASL_MECHANISM=${CONNECT_PRODUCER_CONFLUENT_MONITORING_INTERCEPTOR_SASL_MECHANISM:-$SASL_MECHANISM}

CONNECT_CONSUMER_SECURITY_PROTOCOL=${CONNECT_CONSUMER_SECURITY_PROTOCOL:-$SECURITY_PROTOCOL}
CONNECT_CONSUMER_SASL_JAAS_CONFIG=${CONNECT_CONSUMER_SASL_JAAS_CONFIG:-$SASL_JAAS_CONFIG}
CONNECT_CONSUMER_SASL_MECHANISM=${CONNECT_CONSUMER_SASL_MECHANISM:-$SASL_MECHANISM}
CONNECT_CONSUMER_INTERCEPTOR_CLASSES=${CONNECT_CONSUMER_INTERCEPTOR_CLASSES:-"io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor"}
CONNECT_CONSUMER_CONFLUENT_MONITORING_INTERCEPTOR_BOOTSTRAP_SERVERS=${CONNECT_CONSUMER_CONFLUENT_MONITORING_INTERCEPTOR_BOOTSTRAP_SERVERS:-$BOOTSTRAP_SERVERS}
CONNECT_CONSUMER_CONFLUENT_MONITORING_INTERCEPTOR_SECURITY_PROTOCOL=${CONNECT_CONSUMER_CONFLUENT_MONITORING_INTERCEPTOR_SECURITY_PROTOCOL:-$SECURITY_PROTOCOL}
CONNECT_CONSUMER_CONFLUENT_MONITORING_INTERCEPTOR_SASL_JAAS_CONFIG=${CONNECT_CONSUMER_CONFLUENT_MONITORING_INTERCEPTOR_SASL_JAAS_CONFIG:-$SASL_JAAS_CONFIG}
CONNECT_CONSUMER_CONFLUENT_MONITORING_INTERCEPTOR_SASL_MECHANISM=${CONNECT_CONSUMER_CONFLUENT_MONITORING_INTERCEPTOR_SASL_MECHANISM:-$SASL_MECHANISM}

sleep $STARTUP_DELAY
/etc/confluent/docker/run

