# Note: The files referred in /tmp/alz_accelerator_stacks/ is available here: https://github.com/janegilring/alzstacksdemo

#region Pipeline - GitHub Actions

    # Workflow defintion
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/.github/workflows/alz-bicep-1.yml'

#endregion

#region Stack 1 - Management Group hierarchy

    # Bicep module
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/upstream-releases/v0.14.0/infra-as-code/bicep/orchestration/managementGroupDeployment/managementGroupDeployment.bicep'

    # Parameters file
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/config/custom-parameters/managementGroupsDeployment.parameters.all.json'

    # Parameters file - new parameters file-format released in Bicep v0.18.4 in June 2023
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/config/custom-parameters/managementGroupsDeployment.parameters.all.bicepparam'

    # Pipeline script
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/pipeline-scripts/01-Deploy-ALZ-ManagementGroupsStack.ps1'

#endregion

#region Stack 2 - Logging

    # Bicep module
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/upstream-releases/v0.14.0/infra-as-code/bicep/orchestration/LoggingAndSentinelDeployment/LoggingAndSentinelDeployment.bicep'

    # Parameters file
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/config/custom-parameters/loggingAndSentinelDeployment.parameters.all.json'

    # Pipeline script
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/pipeline-scripts/02-Deploy-ALZLoggingAndSentinelStack.ps1'

#endregion

#region Stack 3 - Custom Azure Policy Definitions

    # Bicep module
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/upstream-releases/v0.14.0/infra-as-code/bicep/orchestration/policyDeployment/policyDeployment.bicep'

    # Parameters file
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/config/custom-parameters/customPolicyDefinitions.parameters.all.json'

    # Pipeline script
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/pipeline-scripts/03-Deploy-ALZCustomPolicyDefinitions.ps1'

#endregion

#region Stack 4 - Connectivity

    # Bicep module
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/upstream-releases/v0.14.0/infra-as-code/bicep/orchestration/connectivityDeployment/connectivityDeployment.bicep'

    # Parameters file
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/config/custom-parameters/connectivityDeployment.parameters.all.json'

    # Pipeline script
    Open-EditorFile -Path '/tmp/alz_accelerator_stacks/pipeline-scripts/04-Deploy-ALZ-ConnectivityStack-HubAndSpoke.ps1'

#endregion