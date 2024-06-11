#!/bin/bash
export GREEN=`tput setaf 2`
export YELLOW=`tput setaf 3`
export RED=`tput setaf 1`
export RESET=`tput sgr0`

if [ -z "$DB_SCRIPT_FOLDER" ]; then
    export DB_SCRIPT_FOLDER="/mysql-scripts"
fi 

log_info() {
  echo -e "$GREEN[INFO]: $@ $RESET"
}

log_warning() {
  echo -e "$YELLOW[WARN]: $@ $RESET"
}

log_error() {
  echo -e "$RED[ERROR]: $@ $RESET"
}

check_input_json() {
    # NOTE: INPUT_JSON is a required environment variable and needs to be in the 
    # following format:
    #
    # {
    #     "db_scripts": [
    #         {
    #             "script_name": "script1.sql",
    #             "database_name": "database1"
    #         },
    #         {
    #             "script_name": "script2.sql",
    #             "database_name": "database2"
    #         }
    #     ]
    # }
    #
    # Scripts must be in the /$DB_SCRIPT_FOLDER folder and the script_name must be the
    # name of the script file. The database_name must be the name of the database
    # that the script will be run against.

    log_info "Validating JSON input..."
    log_info "INPUT_JSON: $INPUT_JSON"

    local db_scripts=$(echo "$INPUT_JSON" | jq -r '.db_scripts')
    if [ -z "$db_scripts" ]; then
        log_error "Invalid input JSON. Missing 'db_scripts' attribute."
        exit 1
    fi

    local script_name
    local database_name
    for script in $(echo "$db_scripts" | jq -cr '.[]'); do
        script_name=$(echo "$script" | jq -r '.script_name')
        database_name=$(echo "$script" | jq -r '.database_name')
        if [ -z "$script_name" ] || [ -z "$database_name" ]; then
            log_error "Invalid input JSON. Missing 'script_name' or 'database_name' field in db_scripts object."
            exit 1
        fi
    done
}

check_jq_installed() {
    if ! command -v jq &> /dev/null; then
        log_error "jq command is not installed. Please install jq."
        exit 1
    fi
}

check_command_status() {
    if [ $? -eq 0 ]; then
        log_info "SUCCESSFUL"
    else
        log_error "FAILED"
        exit 1
    fi
}

check_required_vars() {
    local required_vars="INPUT_JSON DB_HOST DB_PORT DB_USER DB_PWD"
    local missing_vars=""

    for var in $required_vars; do
        if [ -z "${!var}" ]; then
          missing_vars="$missing_vars $var"
        fi
    done

    if [ "$missing_vars" != "" ]; then
        log_error "Missing required environment variables: $missing_vars"
        exit 1
    fi
}

main() {
  if [ "$DB_SSL" == "true" ]; then
      log_info "SSL is enabled"
      export MYSQL_SSL_CA=/mysql-ssl/mysql_ca_bundle.pem
      export DB_SSL_PARAMS="--ssl-ca=$MYSQL_SSL_CA"
  fi

  log_info "Connecting to $DB_HOST:$DB_PORT..."
  # Wait for MySQL to be ready
  until mysqladmin ping $DB_SSL_PARAMS -h"$DB_HOST" -P"$DB_PORT" --silent; do
      log_warning "Waiting for MySQL to be ready..."
      sleep 1
  done

  log_info "MySQL is ready"
  
  # Run each script as defined in INPUT_JSON object
  for script in $(echo "$INPUT_JSON" | jq -cr '.db_scripts.[]'); do
      script_name=$(echo "$script" | jq -r '.script_name')
      database_name=$(echo "$script" | jq -r '.database_name')
  
      log_info "Processing script $script_name for database $database_name"
  
      # Check if the script exists
      if [ ! -f "/$DB_SCRIPT_FOLDER/$script_name" ]; then
          log_error "Script $script_name does not exist."
          exit 1
      fi

      # Create the database if it doesn't exist
      log_warning "Creating database (if not exist): $database_name"
      mysql $DB_SSL_PARAMS -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PWD" -e "CREATE DATABASE IF NOT EXISTS $database_name;"
  
      check_command_status
      
      # Connect to the database and create tables if they do not exist
      log_warning "Connecting to database $database_name and running $script_name..."
      mysql $DB_SSL_PARAMS -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PWD" $database_namme <<EOF
USE $database_name;
source /$DB_SCRIPT_FOLDER/$script_name;
EOF
      
      check_command_status
  done
}

log_info "Starting MySQL db script runner..."
check_required_vars
check_jq_installed
check_input_json
main