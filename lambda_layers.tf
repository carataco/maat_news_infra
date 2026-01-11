resource "aws_lambda_layer_version" "common" {
  layer_name  = "common_deps"
  description = "Common dependencies for all pipelines"
  compatible_runtimes = ["python3.10"]

  filename   = "layers/common_deps.zip"
}

resource "aws_lambda_layer_version" "rss" {
  layer_name  = "rss_deps"
  description = "Common dependencies for RSS pipelines"
  compatible_runtimes = ["python3.10"]

  filename   = "layers/rss_deps.zip"
}
