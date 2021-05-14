locals {
  # Map of all available IAM policies constructs for AWS services
  #
  # See more - https://docs.aws.amazon.com/step-functions/latest/dg/service-integration-iam-templates.html
  #
  # Notes:
  # * `effect` - "Allow" or "Deny" in policy statement (default: Allow)
  # * `actions` - list of actions in policy statement
  # * `condition` - list of condition in policy statement
  # * `default_resources` - list of resources if not provided as argument

  aws_service_policies = {

    # https://docs.aws.amazon.com/step-functions/latest/dg/lambda-iam.html
    lambda = {
      lambda = {
        actions = [
          "lambda:InvokeFunction"
        ]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/sns-iam.html
    sns = {
      sns = {
        actions = [
          "sns:Publish"
        ]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/sqs-iam.html
    sqs = {
      sqs = {
        actions = [
          "sqs:SendMessage"
        ]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/xray-iam.html
    xray = {
      xray = {
        actions = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets"
        ]
        default_resources = ["*"]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/athena-iam.html
    athena_StartQueryExecution_Sync = {
      athena = {
        actions = [
          "athena:startQueryExecution",
          "athena:stopQueryExecution",
          "athena:getQueryExecution",
          "athena:getDataCatalog"
        ]
      }

      s3 = {
        actions = [
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload",
          "s3:CreateBucket",
          "s3:PutObject"
        ]
        default_resources = ["arn:aws:s3:::*"]
      }

      glue = {
        actions = [
          "glue:CreateDatabase",
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:UpdateDatabase",
          "glue:DeleteDatabase",
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:GetTable",
          "glue:GetTables",
          "glue:DeleteTable",
          "glue:BatchDeleteTable",
          "glue:BatchCreatePartition",
          "glue:CreatePartition",
          "glue:UpdatePartition",
          "glue:GetPartition",
          "glue:GetPartitions",
          "glue:BatchGetPartition",
          "glue:DeletePartition",
          "glue:BatchDeletePartition"
        ]
      }

      lakeformation = {
        actions = [
          "lakeformation:GetDataAccess"
        ]
        default_resources = ["*"]
      }
    }

    athena_StartQueryExecution = {
      athena = {
        actions = [
          "athena:startQueryExecution",
          "athena:getDataCatalog"
        ]
      }

      s3 = {
        actions = [
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload",
          "s3:CreateBucket",
          "s3:PutObject"
        ]
        default_resources = ["arn:aws:s3:::*"]
      }

      glue = {
        actions = [
          "glue:CreateDatabase",
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:UpdateDatabase",
          "glue:DeleteDatabase",
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:GetTable",
          "glue:GetTables",
          "glue:DeleteTable",
          "glue:BatchDeleteTable",
          "glue:BatchCreatePartition",
          "glue:CreatePartition",
          "glue:UpdatePartition",
          "glue:GetPartition",
          "glue:GetPartitions",
          "glue:BatchGetPartition",
          "glue:DeletePartition",
          "glue:BatchDeletePartition"
        ]
      }

      lakeformation = {
        actions = [
          "lakeformation:GetDataAccess"
        ]
        default_resources = ["*"]
      }
    }

    athena_StopQueryExecution = {
      athena = {
        actions = [
          "athena:stopQueryExecution"
        ]
      }
    }

    athena_GetQueryExecution = {
      athena = {
        actions = [
          "athena:stopQueryExecution"
        ]
      }
    }

    athena_GetQueryResults = {
      athena = {
        actions = [
          "athena:getQueryResults"
        ]
      }

      s3 = {
        actions = [
          "s3:GetObject"
        ]
        default_resources = ["arn:aws:s3:::*"]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/batch-iam.html
    batch_Sync = {
      batch = {
        actions = [
          "batch:SubmitJob",
          "batch:DescribeJobs",
          "batch:TerminateJob"
        ]
        default_resources = ["*"]
      }

      events = {
        actions = [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule"
        ]
      }
    }

    batch_WaitForTaskToken = {
      batch = {
        actions = [
          "batch:SubmitJob"
        ]
        default_resources = ["*"]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/dynamo-iam.html
    dynamodb = {
      dynamodb = {
        actions = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/ecs-iam.html
    ecs_Sync = {
      ecs = {
        actions = [
          "ecs:RunTask"
        ]
      }

      ecs_Wildcard = {
        actions = [
          "ecs:StopTask",
          "ecs:DescribeTasks"
        ]
        default_resources = ["*"]
      }

      events = {
        actions = [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule"
        ]
      }
    }

    ecs_WaitForTaskToken = {
      ecs = {
        actions = [
          "ecs:RunTask"
        ]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/glue-iam.html
    glue_Sync = {
      glue = {
        actions = [
          "glue:StartJobRun",
          "glue:GetJobRun",
          "glue:GetJobRuns",
          "glue:BatchStopJobRun"
        ]
        default_resources = ["*"]
      }
    }

    glue_WaitForTaskToken = {
      glue = {
        actions = [
          "glue:StartJobRun"
        ]
        default_resources = ["*"]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/sagemaker-iam.html
    sagemaker_CreateTrainingJob_Sync = {
      sagemaker = {
        actions = [
          "sagemaker:CreateTrainingJob",
          "sagemaker:DescribeTrainingJob",
          "sagemaker:StopTrainingJob"
        ]
      }

      sagemaker_Wildcard = {
        actions = [
          "sagemaker:ListTags"
        ]
        default_resources = ["*"]
      }

      sagemaker_IamPassRole = {
        actions = [
          "iam:PassRole"
        ]
        condition = [
          {
            test     = "StringEquals"
            variable = "iam:PassedToService"
            values   = ["sagemaker.amazonaws.com"]
          }
        ]
      }

      events = {
        actions = [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule"
        ]
      }
    }

    sagemaker_CreateTrainingJob_WaitForTaskToken = {
      sagemaker = {
        actions = [
          "sagemaker:CreateTrainingJob"
        ]
      }

      sagemaker_Wildcard = {
        actions = [
          "sagemaker:ListTags"
        ]
        default_resources = ["*"]
      }

      sagemaker_IamPassRole = {
        actions = [
          "iam:PassRole"
        ]
        condition = [
          {
            test     = "StringEquals"
            variable = "iam:PassedToService"
            values   = ["sagemaker.amazonaws.com"]
          }
        ]
      }
    }

    sagemaker_CreateTransformJob_Sync = {
      sagemaker = {
        actions = [
          "sagemaker:CreateTransformJob",
          "sagemaker:DescribeTransformJob",
          "sagemaker:StopTransformJob"
        ]
      }

      sagemaker_Wildcard = {
        actions = [
          "sagemaker:ListTags"
        ]
        default_resources = ["*"]
      }

      sagemaker_IamPassRole = {
        actions = [
          "iam:PassRole"
        ]
        condition = [
          {
            test     = "StringEquals"
            variable = "iam:PassedToService"
            values   = ["sagemaker.amazonaws.com"]
          }
        ]
      }

      events = {
        actions = [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule"
        ]
      }
    }

    sagemaker_CreateTransformJob_WaitForTaskToken = {
      sagemaker = {
        actions = [
          "sagemaker:CreateTransformJob"
        ]
      }

      sagemaker_Wildcard = {
        actions = [
          "sagemaker:ListTags"
        ]
        default_resources = ["*"]
      }

      sagemaker_IamPassRole = {
        actions = [
          "iam:PassRole"
        ]
        condition = [
          {
            test     = "StringEquals"
            variable = "iam:PassedToService"
            values   = ["sagemaker.amazonaws.com"]
          }
        ]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/emr-iam.html
    emr_AddStep = {
      emr = {
        actions = [
          "elasticmapreduce:AddJobFlowSteps",
          "elasticmapreduce:DescribeStep",
          "elasticmapreduce:CancelSteps"
        ]
      }

      events = {
        actions = [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule"
        ]
      }
    }

    emr_CancelStep = {
      emr = {
        actions = [
          "elasticmapreduce:CancelSteps"
        ]
      }
    }

    emr_CreateCluster = {
      emr = {
        actions = [
          "elasticmapreduce:RunJobFlow",
          "elasticmapreduce:DescribeCluster",
          "elasticmapreduce:TerminateJobFlows"
        ]
        default_resources = ["*"]
      }

      iam_PassRole = {
        actions = [
          "iam:PassRole"
        ]
      }

      events = {
        actions = [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule"
        ]
      }
    }

    emr_SetClusterTerminationProtection = {
      emr = {
        actions = [
          "elasticmapreduce:SetTerminationProtection"
        ]
      }
    }

    emr_ModifyInstanceFleetByName = {
      emr = {
        actions = [
          "elasticmapreduce:ModifyInstanceFleet",
          "elasticmapreduce:ListInstanceFleets"
        ]
      }
    }

    emr_ModifyInstanceGroupByName = {
      emr = {
        actions = [
          "elasticmapreduce:ModifyInstanceGroups",
          "elasticmapreduce:ListInstanceGroups"
        ]
      }
    }

    emr_TerminateCluster = {
      emr = {
        actions = [
          "elasticmapreduce:TerminateJobFlows",
          "elasticmapreduce:DescribeCluster"
        ]
      }

      events = {
        actions = [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule"
        ]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/codebuild-iam.html
    codebuild_StartBuild_Sync = {
      codebuild = {
        actions = [
          "codebuild:StartBuild",
          "codebuild:StopBuild",
          "codebuild:BatchGetBuilds"
        ]
      }

      events = {
        actions = [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule"
        ]
      }
    }

    codebuild_StartBuild = {
      codebuild = {
        actions = [
          "codebuild:StartBuild",
          "codebuild:StopBuild",
          "codebuild:BatchGetBuilds"
        ]
      }
    }

    codebuild_StopBuild = {
      codebuild = {
        actions = [
          "codebuild:StopBuild"
        ]
      }
    }

    codebuild_BatchDeleteBuilds = {
      codebuild = {
        actions = [
          "codebuild:BatchDeleteBuilds"
        ]
      }
    }

    codebuild_BatchGetReports = {
      codebuild = {
        actions = [
          "codebuild:BatchGetReports"
        ]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/eks-iam.html
    eks_CreateCluster = {
      eks = {
        actions = [
          "eks:CreateCluster"
        ]
        default_resources = ["*"]
      }

      eks_Wildcard = {
        actions = [
          "eks:DescribeCluster",
          "eks:DeleteCluster" # o'really? Delete? :)
        ]
      }

      eks_IamPassRole = {
        actions = [
          "iam:PassRole"
        ]
        condition = [
          {
            test     = "StringEquals"
            variable = "iam:PassedToService"
            values   = ["eks.amazonaws.com"]
          }
        ]
      }
    }

    eks_CreateNodeGroup = {
      eks = {
        actions = [
          "ec2:DescribeSubnets",
          "eks:CreateNodegroup"
        ]
        default_resources = ["*"]
      }

      eks_Wildcard = {
        actions = [
          "eks:DescribeNodegroup",
          "eks:DeleteNodegroup"
        ]
      }

      iam_Role = {
        actions = [
          "iam:GetRole",
          "iam:ListAttachedRolePolicies"
        ],
      }

      eks_IamPassRole = {
        actions = [
          "iam:PassRole"
        ]
        condition = [
          {
            test     = "StringEquals"
            variable = "iam:PassedToService"
            values   = ["eks.amazonaws.com"]
          }
        ]
      }
    }

    eks_DeleteCluster = {
      eks = {
        actions = [
          "eks:DeleteCluster",
          "eks:DescribeCluster"
        ]
      }
    }

    eks_DeleteNodegroup = {
      eks = {
        actions = [
          "eks:DeleteNodegroup",
          "eks:DescribeNodegroup"
        ]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/api-gateway-iam.html
    apigateway = {
      apigateway = {
        actions = [
          "execute-api:Invoke"
        ]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/stepfunctions-iam.html
    stepfunction_Sync = {
      stepfunction = {
        actions = [
          "states:StartExecution"
        ]
      }

      stepfunction_Wildcard = {
        actions = [
          "states:DescribeExecution",
          "states:StopExecution"
        ]
      }

      events = {
        actions = [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule"
        ]
      }
    }

    stepfunction = {
      stepfunction = {
        actions = [
          "states:StartExecution"
        ]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/eventbridge-iam.html
    eventbridge = {
      eventbridge = {
        actions = [
          "events:PutEvents"
        ]
        default_resources = ["*"]
      }
    }

    # https://docs.aws.amazon.com/step-functions/latest/dg/activities-iam.html
    no_tasks = {
      deny_all = {
        effect            = "Deny"
        actions           = ["*"]
        default_resources = ["*"]
      }
    }

  }
}
