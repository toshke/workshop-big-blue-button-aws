CfhighlanderTemplate do


  Parameters do
    ComponentParam 'DOMAIN_NAME', Ref('DomainName')
    ComponentParam 'ADMIN_EMAIL', Ref('ADMIN_EMAIL')
  end

  Component template: 'simple-vpc', name: 'vpc'

  Component template: 'simple-asg', name: 'asg' do
    parameter name: 'ImageId', value: image_id
    parameter name: 'SubnetIds', value: [FnGetAtt('vpc', 'PublicA')]
    Parameters do
      ComponentParam 'DOMAIN_NAME', Ref('DomainName')
      ComponentParam 'ADMIN_EMAIL', Ref('ADMIN_EMAIL')
    end
  end

end