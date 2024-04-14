<?

$host_a=$_GET['ahost'];
$host_b=$_GET['rhost'];
$ambiente=$_GET['amb'];

echo "<frameset framespacing=\"0\" border=\"0\" frameborder=\"0\" cols=\"*,*\">";
echo 	"<frame name=\"esquerdo\" src=\"http://10.98.22.11/fping4.0/grafico_lat_det.php?ahost=$host_a&ambi=$ambiente\">";
echo 	"<frame name=\"direito\" src=\"http://10.98.22.11/fping4.0/grafico_lat_det.php?ahost=$host_b&ambi=$ambiente\">";
echo 	"<noframes>";
echo 	"<body>";
echo 	"<p>Esta página usa quadros mas seu navegador não aceita quadros.</p>";

echo 	"</body>";
echo 	"</noframes>";
echo "</frameset>";


?>

