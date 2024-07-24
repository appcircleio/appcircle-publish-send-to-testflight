#!/bin/bash
 
      export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8
      export LANGUAGE=en_US.UTF-8

      echo "IPAFileName:$AC_APP_FILE_NAME"
      echo "IPAFileUrl:$AC_APP_FILE_URL"
      echo "AppleId:$AC_APPLE_ID"
      echo "BundleId:$AC_BUNDLE_ID"
      echo "AppleUserName:$AC_APPLE_APP_SPECIFIC_USERNAME"
      echo "ApplicationSpecificPassword:$AC_APPLE_APP_SPECIFIC_PASSWORD"
      echo "AppStoreConnectApiKey:$AC_API_KEY"
      echo "AppStoreConnectApiKeyFileName:$AC_API_KEY_FILE_NAME"
      echo "appleStoreSubmitApiType:$AC_APPLE_STORE_SUBMIT_API_TYPE"
      
      locale
      curl -o "./$AC_APP_FILE_NAME" -k $AC_APP_FILE_URL
       
     if [ "$AC_APPLE_STORE_SUBMIT_API_TYPE" == 1 ] || [ "$AC_APPLE_STORE_SUBMIT_API_TYPE" == "AppStoreConnectApiConnection" ]; then
 
        bundle init
        echo "gem \"fastlane\"">>Gemfile
        bundle install
        mkdir fastlane
        touch fastlane/Appfile
        touch fastlane/Fastfile
        mv $AC_FASTFILE_CONFIG "fastlane/Fastfile"
        mv "$AC_API_KEY" "$AC_API_KEY_FILE_NAME"

        if [ $AC_STACK_TYPE == 10 ]
        then
          bundle exec fastlane doTestFlight --verbose
          if [ $? -eq 0 ]
          then
            echo "TestFlight progress succeeded"
            exit 0
          else
            echo "TestFlight progress failed :" >&2
            exit 1
          fi
        fi
        if [ $AC_STACK_TYPE == 12 ]
        then
          bundle exec fastlane doRelease --verbose
          if [ $? -eq 0 ] 
          then
            echo "Release progress succeeded"
            exit 0
          else
            echo "Release progress failed :" >&2
            exit 1
          fi
        fi
      fi
