CfhighlanderTemplate do


  DependsOn 'lib-iam@0.1.0'

  Parameters do
    ComponentParam 'ImageId', 'ami-08fdde86b93accf1c', type: 'AWS::EC2::Image::Id'
    ComponentParam 'InstanceType', 't3.small'
    ComponentParam 'SubnetIds', type: 'List<AWS::EC2::Subnet::Id>'
    ComponentParam 'VpcId', type: 'AWS::EC2::VPC::Id'
    ComponentParam 'KeyName', type: 'AWS::EC2::KeyPair::KeyName'
  end

end