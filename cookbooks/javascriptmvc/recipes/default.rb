# Copyright (c) 2013, Wojciech Bednarski
# 
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# create sample project directory
directory '/vagrant/projects/Todo' do
  action :create
end

# update apt-get
execute 'update apt-get' do
  command 'apt-get update'
end

# install git
package 'git' do
  package_name 'git-core'
  action :install
end

# install java jre
package 'java' do
  package_name 'openjdk-6-jre-headless'
  action :install
end

# install nginx
package 'nginx' do
  package_name 'nginx'
  action :install
end

# use custom nginx config
template '/etc/nginx/nginx.conf' do
  source 'nginx.conf'
  owner 'root'
  group 'root'
end

# restart nginx
execute 'nginx restart' do
  command 'sudo service nginx restart'
end

# install JavaSriptMVC
if !File.exists?('/vagrant/projects/Todo/jquery')
  bash 'install JavaScriptMVC' do
    cwd '/vagrant/projects/Todo'
    code <<-EOH
      git init
      
      git submodule add git://github.com/bitovi/steal.git
      git submodule add git://github.com/bitovi/documentjs.git
      git submodule add git://github.com/bitovi/funcunit.git
      git submodule add git://github.com/jupiterjs/jquerymx.git jquery
      
      git submodule init
      git submodule update
      
      cd funcunit
      git submodule init
      git submodule update
      
      cd syn
      git checkout master
      
      cd ../..
      ./steal/js steal/make.js
    EOH
  end
end
