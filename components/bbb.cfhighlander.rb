CfhighlanderTemplate do


  Parameters do
    ComponentParam 'DomainName', 'online.example.com', description: 'Domain name for Big Blue Button server'
    ComponentParam 'AdminEmail', 'admin@example.com', description: 'Admin Email address for Lets Encrypt certificate'
  end

  Component template: 'simple-vpc', name: 'vpc'

  Component template: 'simple-asg', name: 'asg' do
    parameter name: 'ImageId', value: image_id
    parameter name: 'SubnetIds', value: [FnGetAtt('vpc', 'PublicA')]
    Parameters do
      ComponentParam 'DOMAIN_NAME', Ref('DomainName')
      ComponentParam 'ADMIN_EMAIL', Ref('AdminEmail')
    end
  end

end