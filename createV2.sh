

PROJECT_NAME="mydotnet"
DEPLOYMENT_CHECK_INTERVAL=10
DEPLOYMENT_CHECK_TIMES=60



function wait_for_application_deployment() {



    DC_NAME=$1 # the name of the deploymentConfig, transmitted as 1st parameter

    DEPLOYMENT_VERSION=

    RC_NAME=

    COUNTER=0



    # Validate Deployment is Active

    while [ ${COUNTER} -lt $DEPLOYMENT_CHECK_TIMES ]

    do



        DEPLOYMENT_VERSION=$(oc get -n ${PROJECT_NAME} dc ${DC_NAME} --template='{{ .status.latestVersion }}')



        RC_NAME="${DC_NAME}-${DEPLOYMENT_VERSION}"



        if [ "${DEPLOYMENT_VERSION}" == "1" ]; then

          break

        fi



        if [ $COUNTER -lt $DEPLOYMENT_CHECK_TIMES ]; then

            COUNTER=$(( $COUNTER + 1 ))

        fi



        if [ $COUNTER -eq $DEPLOYMENT_CHECK_TIMES ]; then

          echo "Max Validation Attempts Exceeded. Failed Verifying Application Deployment..."

          exit 1

        fi

        sleep $DEPLOYMENT_CHECK_INTERVAL



     done



     COUNTER=0



     # Validate Deployment Complete

     while [ ${COUNTER} -lt $DEPLOYMENT_CHECK_TIMES ]

     do



         DEPLOYMENT_STATUS=$(oc get -n ${PROJECT_NAME} rc/${RC_NAME} --template '{{ index .metadata.annotations "openshift.io/deployment.phase" }}')



         if [ ${DEPLOYMENT_STATUS} == "Complete" ]; then

           break

         elif [ ${DEPLOYMENT_STATUS} == "Failed" ]; then

             echo "Deployment Failed!"

             exit 1

         fi



         if [ $COUNTER -lt $DEPLOYMENT_CHECK_TIMES ]; then

             COUNTER=$(( $COUNTER + 1 ))

         fi





         if [ $COUNTER -eq $DEPLOYMENT_CHECK_TIMES ]; then

           echo "Max Validation Attempts Exceeded. Failed Verifying Application Deployment..."

           exit 1

         fi



         sleep $DEPLOYMENT_CHECK_INTERVAL



      done



}

oc new-build --binary --name=dotnethello-v2
oc start-build dotnethello-v2 --from-dir=. --follow
oc set probe dc/dotnethello-v2 --readiness --get-url=http://:5000
oc new-app dotnethello-v2

echo "Waiting for v2 DEPLOYMENT to complete..."

wait_for_application_deployment "dotnethello-v2"

oc patch route/dotnethello -p '{"spec": {"to": {"name": "dotnethello-v2" }}}'