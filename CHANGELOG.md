# Change Log

All notable changes to this project will be documented in this file.

<a name="unreleased"></a>
## [Unreleased]

- feat: adding PassRole for ECS tasks as it is required for Fargate ([#24](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/24))


<a name="v2.4.0"></a>
## [v2.4.0] - 2021-09-01

- feat: Enable X-Ray tracing on Step Function if set to true in service_integrations ([#22](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/22))


<a name="v2.3.0"></a>
## [v2.3.0] - 2021-05-25

- chore: Remove check boxes that don't render properly in module doc ([#18](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/18))


<a name="v2.2.0"></a>
## [v2.2.0] - 2021-05-15

- feat: Add support for EventBridge integration with PutEvents tasks ([#17](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/17))


<a name="v2.1.0"></a>
## [v2.1.0] - 2021-05-12

- fix: Fixed service_integration type conversion with tomap ([#16](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/16))
- chore: update CI/CD to use stable `terraform-docs` release artifact and discoverable Apache2.0 license ([#13](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/13))


<a name="v2.0.0"></a>
## [v2.0.0] - 2021-04-26

- feat: Shorten outputs (removing this_) ([#12](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/12))


<a name="v1.3.0"></a>
## [v1.3.0] - 2021-04-07

- feat: Configure cloudwatch logging for step functions module ([#9](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/9))
- chore: update documentation and pin `terraform_docs` version to avoid future changes ([#10](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/10))
- chore: align ci-cd static checks to use individual minimum Terraform versions ([#6](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/6))
- chore: Run pre-commit terraform_docs hook ([#5](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/5))
- chore: add ci-cd workflow for pre-commit checks ([#4](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/4))


<a name="v1.2.0"></a>
## [v1.2.0] - 2021-02-20

- chore: update documentation based on latest `terraform-docs` which includes module and resource sections ([#3](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/3))


<a name="v1.1.0"></a>
## [v1.1.0] - 2021-02-12

- feat: Add support for Step Function type - STANDARD (default) or EXPRESS ([#2](https://github.com/terraform-aws-modules/terraform-aws-step-functions/issues/2))


<a name="v1.0.0"></a>
## [v1.0.0] - 2020-11-21

- fix: IAM policy integration


<a name="v0.1.0"></a>
## v0.1.0 - 2020-11-21

- Initial commit


[Unreleased]: https://github.com/terraform-aws-modules/terraform-aws-step-functions/compare/v2.4.0...HEAD
[v2.4.0]: https://github.com/terraform-aws-modules/terraform-aws-step-functions/compare/v2.3.0...v2.4.0
[v2.3.0]: https://github.com/terraform-aws-modules/terraform-aws-step-functions/compare/v2.2.0...v2.3.0
[v2.2.0]: https://github.com/terraform-aws-modules/terraform-aws-step-functions/compare/v2.1.0...v2.2.0
[v2.1.0]: https://github.com/terraform-aws-modules/terraform-aws-step-functions/compare/v2.0.0...v2.1.0
[v2.0.0]: https://github.com/terraform-aws-modules/terraform-aws-step-functions/compare/v1.3.0...v2.0.0
[v1.3.0]: https://github.com/terraform-aws-modules/terraform-aws-step-functions/compare/v1.2.0...v1.3.0
[v1.2.0]: https://github.com/terraform-aws-modules/terraform-aws-step-functions/compare/v1.1.0...v1.2.0
[v1.1.0]: https://github.com/terraform-aws-modules/terraform-aws-step-functions/compare/v1.0.0...v1.1.0
[v1.0.0]: https://github.com/terraform-aws-modules/terraform-aws-step-functions/compare/v0.1.0...v1.0.0
