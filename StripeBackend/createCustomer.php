
<?php


require_once('./stripe-php/init.php');
\Stripe\Stripe::setApiKey('sk_test_LC3fJ8Opl8EhUT7AZatJOlTK00fj9qw3sm');


$email =  $_POST['email'] ;
$fullName = $_POST['name'];
$phone	= $_POST['phone'];

$key = \Stripe\Customer::create([
  'description' => 'testing','email'=>"$email",'phone'=>"$phone", 'name'=>$fullName
]);


echo json_encode($key);

?>
