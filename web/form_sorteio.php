<html>

<head>
<meta http-equiv="Content-Language" content="pt-br">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Pagina de Sorteio de grupos</title>
<style type="text/css"> 
@import url("estilo.css");
</style> 
</head>

<body>

<p align="left"><a href="pesquisa_sorteio.php">sorteios realizados</a> | </p> 
<form method="POST" action="sorteio.php">
	<p>&nbsp;</p>
	<table border="1" width="869">
		<tr>
			<td width="312"><input type="submit" value="Sortear" name="B1"></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2">Sorteio de Grupos:</td>
		</tr>
		<tr>
			<td width="312">nome sorteio:</td>
			<td>
			<input type="text" name="nome_sorteio" size="74" value="copa kkk primeira edição" tabindex="1"></td>
		</tr>
		<tr>
			<td width="312">quantidade de times por grupo:</td>
			<td>
			&nbsp;<!--webbot bot="Validation" s-data-type="Integer" s-number-separators="x" --><input type="text" name="quantidade" size="20" tabindex="2" value="4"></td>
		</tr>
		<tr>
			<td width="312">times participantes (separador por &quot;;&quot; exemplo: 
			Brasil;italia;argentina;)</td>
			<td><textarea rows="9" name="times" cols="64" tabindex="3"></textarea></td>
		</tr>
	</table>
</form>

</body>

</html>
