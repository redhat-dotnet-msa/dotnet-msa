

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


oc new-build --name dotnethello-v3 --binary -l app=dotnethello-v3

oc start-build dotnethello-v3 --from-dir=. --follow

oc set probe dc/dotnethello-v3 --readiness --get-url=http://:5000

echo "Waiting for v3 DEPLOYMENT to complete..."

oc new-app dotnethello-v3 -l app=dotnethello-v3

oc patch dc/dotnethello-v2 -p '{"spec":{"template":{"metadata":{"labels":{"svc":"v3-dotnethello"}}}}}'

wait_for_application_deployment "dotnethello-v3"
oc patch dc/dotnethello-v3 -p '{"spec":{"template":{"metadata":{"labels":{"svc":"v3-dotnethello"}}}}}'
#wait_for_application_deployment "dotnethello-blue"

oc patch svc/dotnethello-v2 -p '{"spec":{"selector":{"svc":"v3-dotnethello","app": null, "deploymentconfig": null}, "sessionAffinity":"ClientIP"}}'
