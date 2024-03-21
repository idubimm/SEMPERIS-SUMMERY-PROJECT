import sys
import requests
import json
import subprocess

   
DOCKER_ENDPOINTS = {
    'API_URL' : 'https://hub.docker.com/v2/',
    'LOGIN' : 'users/login'     ,
    'REPO_TAGS' : 'namespaces/{user}/repositories/{repo_name}/tags',
    'REPO_DELETE_TAG' : 'repositories/{user}/{repo_name}/tags/{tag_name}'
}

DOCKER_RESPONSE = {
    'TOKEN':''      
}

# Buld format : VESION.RELEASE.BUILD
BUILD_POSITION_4INCREMENTAL_TYPES = {
    "VERSION":0,
    "RELEASE" : 1,
    "BUILD": 2    
}

LATEST_TAG_NAME = "latest"

def get_docker_login_url() : 
    return DOCKER_ENDPOINTS['API_URL'] + DOCKER_ENDPOINTS['LOGIN']  
def get_docker_repo_url(user,repo_name):
    str = DOCKER_ENDPOINTS["API_URL"] + DOCKER_ENDPOINTS["REPO_TAGS"]  
    return str.replace('{user}',user).replace('{repo_name}',repo_name)
def get_docker_delete_tag_url(user,repo_name,tag_name):
    str = DOCKER_ENDPOINTS["API_URL"] + DOCKER_ENDPOINTS["REPO_DELETE_TAG"]  
    return str.replace('{user}',user).replace('{repo_name}',repo_name).replace('{tag_name}',tag_name)


def get_last_build_tag(tags_object):
    return max(tags_object, key=lambda x: evaluate_tag_name(x['tag_name']))['tag_name']
    # return max(tags_object, key=lambda x: int(x['tag_name'].replace('.','')))['tag_name']
 

def increase_build_tag(current_buildnumber,incremental_type):
    build_number_array = current_buildnumber[::1].split('.')
    new_type_value = int(build_number_array[BUILD_POSITION_4INCREMENTAL_TYPES[incremental_type]])+1
    build_number_array[BUILD_POSITION_4INCREMENTAL_TYPES[incremental_type]]=str(new_type_value)
    array_iteration_calculation = len(BUILD_POSITION_4INCREMENTAL_TYPES)-BUILD_POSITION_4INCREMENTAL_TYPES[incremental_type]
    for i in range(array_iteration_calculation-1):
        build_number_array[len(build_number_array) - i - 1 ]='0'
        
    # next_buildnumber = f'{build_number_array[2]}.{build_number_array[1]}.{build_number_array[0]}'
    next_buildnumber = ".".join(build_number_array)
    print (f' {incremental_type} number increaed from {current_buildnumber} to {next_buildnumber}')
    return  next_buildnumber

def get_header_with_token(token)  : 
    return { 'Accept': 'application/json',
             'Authorization': 'Bearer ' + token}
    
def api_login(user,password):
    url = get_docker_login_url()
    payload = json.dumps({
        "username": user,
        "password": password
        })
    headers = {
         'Content-Type': 'application/json'
         }    
    return requests.request("POST", url=url,headers=headers,data=payload)

def api_get_repo_list(repo_name, user,token):
        url = get_docker_repo_url(user,repo_name)
        headers = get_header_with_token(token) 
        response = requests.request("GET", url=url, headers=headers, data={})
        return response

def api_delete_tag_name(user,repo_name,token,tag_name):
        url = get_docker_delete_tag_url(user,repo_name,tag_name)
        headers = get_header_with_token(token) 
        response = requests.request("DELETE", url=url, headers=headers, data={})
        return response
            
    
def login_to_docker(password,user): 
        response = api_login( password=password,user=user)
        
        if response.status_code == 200:
            DOCKER_RESPONSE['TOKEN'] = response.json()['token']
            print('connected to docker hub ') 
            return True
        else:
            print(f'faile to login to docker hub , status : {response.status_code} , {response["detail"]}')
            return False

def get_repo_tags_json(repo_name , user)  :
     token = DOCKER_RESPONSE["TOKEN"]
     if (token):
        response = api_get_repo_list(repo_name , user , token)
        return response.json()
     else:
        print('error : docker response [TOKEN] have no value')  
        return {}
      
def parse_json_to_tags_list(repo_json):
    result_list = [
    {
        "id": item["id"],
        "push_date": item["tag_last_pushed"],
        "last_pulled": item["tag_last_pulled"],
        "tag_name":item["name"]
    }
    for item in repo_json["results"]
    if item["name"] != LATEST_TAG_NAME
    ]
    return  result_list

def evaluate_tag_name(tag_name) : 
    tag_elements = tag_name.split('.')
    tag_elements.reverse() 
    value = sum(int(element) * (10000) ** i for i, element in enumerate(tag_elements))
    # print(f'evaluating {tag_name} ==> {value}')
    return value
    

def get_list_of_tags_to_delete(repository_tags,number_builds_2keep):
    if len(repository_tags) < number_builds_2keep - 1 :
        return []
    else :
        sorted_list = sorted(repository_tags, key=lambda x: evaluate_tag_name(x['tag_name']))
        return sorted_list[:len(repository_tags)-number_builds_2keep+1]
    

def get_next_tagname_and_tags_2delete(repository_tags,build_incremental_type,number_builds_2keep):
    max_tag_name = get_last_build_tag(repository_tags) 
    next_tag_name = increase_build_tag(max_tag_name,build_incremental_type)
    tags_to_delete = get_list_of_tags_to_delete(repository_tags,number_builds_2keep)
    return {"next_tag_name" : next_tag_name , "tags_to_delete":tags_to_delete}    

def get_repo_name_with_tag(user,repo_name,tag):
    return  f'{user}/{repo_name}:{tag}'

def get_repo_name_latest_tag(user,repo_name):
      return  get_repo_name_with_tag(user,repo_name,LATEST_TAG_NAME)
  
def create_docker_image_tag_for_push(user,repo_name,tag) :
    tag_name =  get_repo_name_with_tag(user,repo_name,tag)
    tag_name_lts = get_repo_name_latest_tag(user,repo_name)
    subprocess.run (f'docker tag {repo_name} {tag_name} ',shell=True,capture_output=True,text=True,check=True)
    subprocess.run (f'docker tag {repo_name} {tag_name_lts} ',shell=True,capture_output=True,text=True,check=True)
    pushed_image = subprocess.run (f'docker push {tag_name}',shell=True,capture_output=True)
    if pushed_image.returncode == 0:
        print(f'{tag_name} was pushed to repository {user}/{repo_name}')
        return True
    else: 
        print (f'failed to push {tag_name} , error is {pushed_image.stderr.decode()}')
        raise Exception (pushed_image.stderr.decode())

    
def delete_old_images(user,repo_name,control_obj):
    tags_to_delete = control_obj["tags_to_delete"]
    token = DOCKER_RESPONSE["TOKEN"]
    failed_list = []
    for tag_reference in tags_to_delete:
       tag_name = tag_reference['tag_name']
       print (f'deleting old build : {tag_name} ')
       response = api_delete_tag_name(user,repo_name,token,tag_name)
       if response.status_code!=204:
           failed_list.push({"tag_name":f'{tag_name}',"status_code":f'response.status_code' , "reason":f'{response.reason}'})
       else: 
           print (f'{tag_name} deleted successfuly ')
           
    if failed_list:
        raise Exception (f'faile to delete old builds, details :  \n {failed_list}')
        
    else :
        #  try to delete 'latest' tag name id exist , if not do nothing
        try:
            api_delete_tag_name(user,repo_name,token,LATEST_TAG_NAME)
        except: 
            pass
            # print("no latest tag name to delete")
        return True
       
    
#  if I use try catch then jenkins does not recignize failure , so I removed it
# Itried with returning 1 or -1 but did not succeed 
def push_docker_repo_to_hub(repo_name , user , password,build_incremental_type,number_builds_2keep) : 
    # try:
        if login_to_docker(user=user,password=password):    
            repository_obj = get_repo_tags_json(repo_name,user)
            repository_tags_obj = parse_json_to_tags_list(repository_obj)
            control_obj = get_next_tagname_and_tags_2delete(repository_tags_obj,build_incremental_type,int(number_builds_2keep))
            if create_docker_image_tag_for_push(user,repo_name,control_obj["next_tag_name"]):
                if delete_old_images(user,repo_name,control_obj) :
                   pushed_image = subprocess.run (f'docker push {get_repo_name_latest_tag(user,repo_name)}',shell=True,capture_output=True)
            else:
                raise Exception ('falied to delete old images')
        else:
            raise Exception ('failed to login to dockerhub with {user} ' )
 
arg = sys.argv

# this file is executed with this parameters from jenklins , also a debug file exist with execution params
push_docker_repo_to_hub(user=arg[1] , password=arg[2] , repo_name=arg[3] , build_incremental_type=arg[4], number_builds_2keep=arg[5])
