import json
from urllib.parse import parse_qsl, urljoin, urlparse
from urllib.parse import unquote
import urllib.request
import boto3

try:
    from urllib import request
except ImportError:
    import urllib
    
s3 = boto3.client('s3')

def lambda_handler(event, context):
  query = event['queryStringParameters']
  if len(query) == 0:
    welcome = """
<!doctype html>
<html lang="en" class="h-100">
    <head>
        <style>
body {
  background-image: url('https://hdwallsource.com/img/2014/2/minimalist-wallpaper-5750-5915-hd-wallpapers.jpg');
}
        .container {
            text-align: center;
        }

        .form {
            width: 100%;
            text-align: center;
        }
    </style>
    </head>
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
    <body class="h-100">
        <div class="container h-100">
                    <!-- Form -->
                    <form class="form-example" action="?" method="GET">
                       <h1>XML File Downloader</h1>
                        <div class="form-group">
                            <label for="username">Insert URL:</label>
                            <center>
                            <input type="text" class="form-control username" id="url" name="url" style="width: 700px"<br></br>
                           </center>
                        <input type="submit" class="btn btn-warning"></input>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
    """
    return {
    'statusCode': 200,
    'headers': {"Content-Type":"text/html"},
    'body': welcome
    }
  else:
    Url = query['url']
    print(Url)
    print(unquote(Url))
    url = unquote(Url)
            
    req = urllib.request.Request(
      url,
      data=None,
      headers={
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.47 Safari/537.36'
          } 
    )
    
    response = request.urlopen(req)
    XML = response.read()
    XML = XML.decode("UTF-8")
    urlp = urlparse(url)
    s3.put_object(Bucket='lambdataskbucketml', Key=urlp.netloc+'.xml', Body=XML)
    event['queryStringParameters'] = ""
        
    return {
    'statusCode': 200,
    'headers': {"Content-Type":"text/html"},
    'body': """
    <!doctype html>
    <head>
        <style>
        

       body {
  background-image: url('https://hdwallsource.com/img/2014/2/minimalist-wallpaper-5750-5915-hd-wallpapers.jpg');
}
    </style>
    </head>
<html lang="en" class="h-100">
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
    <body>
<center>
    <h2>XML file has been successfully downloaded!</h2>
    <form>
 <input type="button" class="btn btn-success" value="Return" onclick="history.go(-1)">
</form>
    </body>
    </center>
    </div>
    
</html>
    """
    }