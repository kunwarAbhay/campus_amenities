<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<style>
    body {
        background-image:  linear-gradient(#dddddd36 , #ffffff00) ,url(images/bg-iitp.jpg);
        background-size: cover;
        height: 100vh;
        background-position: center;
    }

    .contributor{
        background-color: #fff;
    }
</style>

<?php
    session_start();
    session_destroy();
?>


<h1 class="text-center mb-4">Home Page</h1>
<h2 class="text-center mb-4">CS355: Database Lab Project</h2>

<div class="container d-flex justify-content-between mb-4">
  <div class="border border-4 rounded border-dark p-4 contributor">
    <div class="font-weight-bold">Kaushal Raj</div>
    <div class="font-weight-bold">2001CS36</div>
  </div>
  <div class="border border-4 rounded border-dark p-4 contributor">
    <div class="font-weight-bold">Kunwar Abhay Rai </div>
    <div class="font-weight-bold">2001CS40</div>
  </div>
  <div class="border border-4 rounded border-dark p-4 contributor">
    <div class="font-weight-bold">Ashutosh Kumar</div> 
    <div class="font-weight-bold">2001CS11</div>
  </div>
  <div class="border border-4 rounded border-dark p-4 contributor">
    <div class="font-weight-bold">Vipul Kumar Gond</div>
    <div class="font-weight-bold">2001CS77</div>
  </div>
</div>

<div class="container text-center">
    <a href="guest_house/home_guest_house.php" class="btn btn-primary">Guest House</a>
    <a href="market/home_market.php" class="btn btn-primary">Market</a>
</div>