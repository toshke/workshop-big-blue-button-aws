CloudFormation do

  name = external_parameters.fetch(:name)
  instance_userdata = external_parameters.fetch(:user_data)
  capacity = external_parameters.fetch(:capacity)
  termination_policies = external_parameters.fetch(:termination_policies)

  EC2_SecurityGroup(:ASGSecGroup) do
    VpcId Ref('VpcId')
    GroupDescription "#{name} - ASG SG"
  end

  Output(:SecurityGroup) do
    Value(Ref(:ASGSecGroup))
  end

  IAM_Role(:Role) do
    Path '/'
    AssumeRolePolicyDocument service_assume_role_policy('ec2')
  end

  IAM_InstanceProfile(:InstanceProfile) {
    Path '/'
    Roles [Ref(:Role)]
  }

  Condition('HasKey', FnNot(FnEquals(Ref(:KeyName), '')))
  EC2_LaunchTemplate(:LaunchTemplate) do
    LaunchTemplateData({
        IamInstanceProfile: { Arn: FnGetAtt(:InstanceProfile, :Arn) },
        ImageId: Ref(:ImageId),
        InstanceInitiatedShutdownBehavior: shutdown_behaviour,
        InstanceType: Ref(:InstanceType),
        KeyName: FnIf('HasKey', Ref(:KeyName), Ref('AWS::NoValue')),
        SecurityGroupIds: [Ref(:ASGSecGroup)],
        UserData: FnBase64(FnSub(instance_userdata))
    })
    LaunchTemplateName "#{name}-lt"
  end

  AutoScaling_AutoScalingGroup(:ASG) do
    AutoScalingGroupName "#{name}"
    # VPCZoneIdentifier FnSplit(',', FnJoin(',', Ref(:SubnetIds)))
    VPCZoneIdentifier ['subnet-07a6d56efa21bdcc0']
    LaunchTemplate ({ LaunchTemplateId: Ref(:LaunchTemplate) , Version: FnGetAtt(:LaunchTemplate, :LatestVersionNumber)})
    MinSize capacity.fetch(:min, '1')
    MaxSize capacity.fetch(:max, '1')
    DesiredCapacity capacity.fetch(:desired, '1')
    TerminationPolicies termination_policies
  end

end