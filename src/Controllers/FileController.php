<?php

namespace App\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Views\Twig;
use Psr\Container\ContainerInterface;
class FileController{
    private $baseDir = './downloadable_files/';
    private Twig $twig;
    public function __construct(ContainerInterface $container){
        $this->twig = $container->get("twig");
    }

    // List all files in the directory
    public function listFiles(Request $request, Response $response, array $args): Response
    {
        $files = [];
        if (is_dir($this->baseDir)) {
            $files = array_diff(scandir($this->baseDir), ['.', '..']);
        }
        
        // $response->getBody()->write(json_encode(['files' => array_values($files)]));
        return $this->twig->render($response, "file-view.html.twig", ["files" => $files]);
        // return $response->withHeader('Content-Type', 'application/json');
    }

    // Serve a file for download
    public function downloadFile(Request $request, Response $response, array $args): Response
    {
        // $filename = $args['filename'] ?? '';
        $filename = $_GET['file'];
        $files = array_diff(scandir($this->baseDir), ['.', '..']);
        

        // error_log(print_r($_GET, true));
        if (!in_array($filename, array_keys($files))) {
            $response->getBody()->write(json_encode(['error' => 'File not found']));
            return $response->withStatus(404)->withHeader('Content-Type', 'application/json');
        }

        $filePath = "./downloadable_files/" . $files[$filename];
        error_log($filePath);
        // Serve the file
        $response = $response
            ->withHeader('Content-Description', 'File Transfer')
            ->withHeader('Content-Type', mime_content_type($filePath))
            ->withHeader('Content-Disposition', 'attachment; filename="' . basename($filePath) . '"')
            ->withHeader('Content-Length', filesize($filePath));

        $stream = fopen($filePath, 'r');
        $response->getBody()->write(stream_get_contents($stream));
        fclose($stream);

        return $response;
    }
}
