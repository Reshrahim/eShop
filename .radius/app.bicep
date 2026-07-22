extension radius

param environment string

@secure()
param postgresPassword string

@description('Image tag injected by the deploy workflow (commit SHA). Containers build from build.source, so this is used only as a build/version marker.')
param image string = ''

resource eshopApp 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'eshop'
  properties: {
    environment: environment
  }
}

resource catalogDb 'Radius.Data/postgreSqlDatabases@2025-08-01-preview' = {
  name: 'catalogdb'
  properties: {
    environment: environment
    application: eshopApp.id
    database: 'catalogdb'
    size: 'S'
    username: 'myadmin'
    password: postgresPassword
    codeReference: 'src/eShop.AppHost/Program.cs#L15'
  }
}

resource identityDb 'Radius.Data/postgreSqlDatabases@2025-08-01-preview' = {
  name: 'identitydb'
  properties: {
    environment: environment
    application: eshopApp.id
    database: 'identitydb'
    size: 'S'
    username: 'myadmin'
    password: postgresPassword
    codeReference: 'src/eShop.AppHost/Program.cs#L16'
  }
}

resource orderingDb 'Radius.Data/postgreSqlDatabases@2025-08-01-preview' = {
  name: 'orderingdb'
  properties: {
    environment: environment
    application: eshopApp.id
    database: 'orderingdb'
    size: 'S'
    username: 'myadmin'
    password: postgresPassword
    codeReference: 'src/eShop.AppHost/Program.cs#L17'
  }
}

resource webhooksDb 'Radius.Data/postgreSqlDatabases@2025-08-01-preview' = {
  name: 'webhooksdb'
  properties: {
    environment: environment
    application: eshopApp.id
    database: 'webhooksdb'
    size: 'S'
    username: 'myadmin'
    password: postgresPassword
    codeReference: 'src/eShop.AppHost/Program.cs#L18'
  }
}

resource redisCache 'Radius.Data/redisCaches@2025-08-01-preview' = {
  name: 'redis'
  properties: {
    environment: environment
    application: eshopApp.id
    size: 'S'
    codeReference: 'src/eShop.AppHost/Program.cs#L7'
  }
}

resource eventBus 'Radius.Messaging/rabbitMQ@2025-08-01-preview' = {
  name: 'eshop-eventbus-reabdul'
  properties: {
    environment: environment
    application: eshopApp.id
    queue: 'eventbus'
    codeReference: 'src/eShop.AppHost/Program.cs#L8'
  }
}

resource identityImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'identity-api-image'
  properties: {
    environment: environment
    application: eshopApp.id
    build: {
      source: 'git::https://github.com/Reshrahim/eShop.git?ref=reshrahim-refactored-succotash'
      dockerfile: 'src/Identity.API/Dockerfile'
    }
    codeReference: 'src/Identity.API/Dockerfile'
  }
}

resource basketImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'basket-api-image'
  properties: {
    environment: environment
    application: eshopApp.id
    build: {
      source: 'git::https://github.com/Reshrahim/eShop.git?ref=reshrahim-refactored-succotash'
      dockerfile: 'src/Basket.API/Dockerfile'
    }
    codeReference: 'src/Basket.API/Dockerfile'
  }
}

resource catalogImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'catalog-api-image'
  properties: {
    environment: environment
    application: eshopApp.id
    build: {
      source: 'git::https://github.com/Reshrahim/eShop.git?ref=reshrahim-refactored-succotash'
      dockerfile: 'src/Catalog.API/Dockerfile'
    }
    codeReference: 'src/Catalog.API/Dockerfile'
  }
}

resource orderingImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'ordering-api-image'
  properties: {
    environment: environment
    application: eshopApp.id
    build: {
      source: 'git::https://github.com/Reshrahim/eShop.git?ref=reshrahim-refactored-succotash'
      dockerfile: 'src/Ordering.API/Dockerfile'
    }
    codeReference: 'src/Ordering.API/Dockerfile'
  }
}

resource orderProcessorImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'order-processor-image'
  properties: {
    environment: environment
    application: eshopApp.id
    build: {
      source: 'git::https://github.com/Reshrahim/eShop.git?ref=reshrahim-refactored-succotash'
      dockerfile: 'src/OrderProcessor/Dockerfile'
    }
    codeReference: 'src/OrderProcessor/Dockerfile'
  }
}

resource paymentProcessorImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'payment-processor-image'
  properties: {
    environment: environment
    application: eshopApp.id
    build: {
      source: 'git::https://github.com/Reshrahim/eShop.git?ref=reshrahim-refactored-succotash'
      dockerfile: 'src/PaymentProcessor/Dockerfile'
    }
    codeReference: 'src/PaymentProcessor/Dockerfile'
  }
}

resource webhooksImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'webhooks-api-image'
  properties: {
    environment: environment
    application: eshopApp.id
    build: {
      source: 'git::https://github.com/Reshrahim/eShop.git?ref=reshrahim-refactored-succotash'
      dockerfile: 'src/Webhooks.API/Dockerfile'
    }
    codeReference: 'src/Webhooks.API/Dockerfile'
  }
}

resource webhooksClientImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'webhooksclient-image'
  properties: {
    environment: environment
    application: eshopApp.id
    build: {
      source: 'git::https://github.com/Reshrahim/eShop.git?ref=reshrahim-refactored-succotash'
      dockerfile: 'src/WebhookClient/Dockerfile'
    }
    codeReference: 'src/WebhookClient/Dockerfile'
  }
}

resource webAppImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'webapp-image'
  properties: {
    environment: environment
    application: eshopApp.id
    build: {
      source: 'git::https://github.com/Reshrahim/eShop.git?ref=reshrahim-refactored-succotash'
      dockerfile: 'src/WebApp/Dockerfile'
    }
    codeReference: 'src/WebApp/Dockerfile'
  }
}

resource identityContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'identity-api'
  properties: {
    environment: environment
    application: eshopApp.id
    containers: {
      identity: {
        image: identityImage.properties.imageReference
        env: {
          ASPNETCORE_ENVIRONMENT: {
            value: 'Development'
          }
          ConnectionStrings__identitydb: {
            value: 'Host=${identityDb.properties.host};Port=${identityDb.properties.port};Database=identitydb;Username=myadmin;Password=${postgresPassword}'
          }
        }
        ports: {
          web: {
            containerPort: 8080
          }
        }
      }
    }
    connections: {
      identitydb: {
        source: identityDb.id
      }
    }
    codeReference: 'src/Identity.API/Program.cs'
  }
}

resource basketContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'basket-api'
  properties: {
    environment: environment
    application: eshopApp.id
    containers: {
      basket: {
        image: basketImage.properties.imageReference
        env: {
          ASPNETCORE_ENVIRONMENT: {
            value: 'Development'
          }
          Identity__Url: {
            value: 'http://identity-api:8080'
          }
          ConnectionStrings__redis: {
            value: '${redisCache.properties.host}:${redisCache.properties.port}'
          }
          ConnectionStrings__eventbus: {
            valueFrom: {
              secretKeyRef: {
                secretName: eventBus.properties.secrets.name
                key: 'connectionString'
              }
            }
          }
        }
        ports: {
          web: {
            containerPort: 8080
          }
        }
      }
    }
    connections: {
      redis: {
        source: redisCache.id
      }
      rabbitmq: {
        source: eventBus.id
      }
      identity: {
        source: identityContainer.id
      }
    }
    codeReference: 'src/Basket.API/Program.cs'
  }
}

resource catalogContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'catalog-api'
  properties: {
    environment: environment
    application: eshopApp.id
    containers: {
      catalog: {
        image: catalogImage.properties.imageReference
        env: {
          ASPNETCORE_ENVIRONMENT: {
            value: 'Development'
          }
          ConnectionStrings__catalogdb: {
            value: 'Host=${catalogDb.properties.host};Port=${catalogDb.properties.port};Database=catalogdb;Username=myadmin;Password=${postgresPassword}'
          }
          ConnectionStrings__eventbus: {
            valueFrom: {
              secretKeyRef: {
                secretName: eventBus.properties.secrets.name
                key: 'connectionString'
              }
            }
          }
        }
        ports: {
          web: {
            containerPort: 8080
          }
        }
      }
    }
    connections: {
      catalogdb: {
        source: catalogDb.id
      }
      rabbitmq: {
        source: eventBus.id
      }
    }
    codeReference: 'src/Catalog.API/Program.cs'
  }
}

resource orderingContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'ordering-api'
  properties: {
    environment: environment
    application: eshopApp.id
    containers: {
      ordering: {
        image: orderingImage.properties.imageReference
        env: {
          ASPNETCORE_ENVIRONMENT: {
            value: 'Development'
          }
          Identity__Url: {
            value: 'http://identity-api:8080'
          }
          ConnectionStrings__orderingdb: {
            value: 'Host=${orderingDb.properties.host};Port=${orderingDb.properties.port};Database=orderingdb;Username=myadmin;Password=${postgresPassword}'
          }
          ConnectionStrings__eventbus: {
            valueFrom: {
              secretKeyRef: {
                secretName: eventBus.properties.secrets.name
                key: 'connectionString'
              }
            }
          }
        }
        ports: {
          web: {
            containerPort: 8080
          }
        }
      }
    }
    connections: {
      orderingdb: {
        source: orderingDb.id
      }
      rabbitmq: {
        source: eventBus.id
      }
      identity: {
        source: identityContainer.id
      }
    }
    codeReference: 'src/Ordering.API/Program.cs'
  }
}

resource orderProcessorContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'order-processor'
  properties: {
    environment: environment
    application: eshopApp.id
    containers: {
      orderProcessor: {
        image: orderProcessorImage.properties.imageReference
        env: {
          ASPNETCORE_ENVIRONMENT: {
            value: 'Development'
          }
          ConnectionStrings__orderingdb: {
            value: 'Host=${orderingDb.properties.host};Port=${orderingDb.properties.port};Database=orderingdb;Username=myadmin;Password=${postgresPassword}'
          }
          ConnectionStrings__eventbus: {
            valueFrom: {
              secretKeyRef: {
                secretName: eventBus.properties.secrets.name
                key: 'connectionString'
              }
            }
          }
        }
      }
    }
    connections: {
      orderingdb: {
        source: orderingDb.id
      }
      rabbitmq: {
        source: eventBus.id
      }
      ordering: {
        source: orderingContainer.id
      }
    }
    codeReference: 'src/OrderProcessor/Program.cs'
  }
}

resource paymentProcessorContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'payment-processor'
  properties: {
    environment: environment
    application: eshopApp.id
    containers: {
      paymentProcessor: {
        image: paymentProcessorImage.properties.imageReference
        env: {
          ASPNETCORE_ENVIRONMENT: {
            value: 'Development'
          }
          ConnectionStrings__eventbus: {
            valueFrom: {
              secretKeyRef: {
                secretName: eventBus.properties.secrets.name
                key: 'connectionString'
              }
            }
          }
        }
      }
    }
    connections: {
      rabbitmq: {
        source: eventBus.id
      }
    }
    codeReference: 'src/PaymentProcessor/Program.cs'
  }
}

resource webhooksContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'webhooks-api'
  properties: {
    environment: environment
    application: eshopApp.id
    containers: {
      webhooks: {
        image: webhooksImage.properties.imageReference
        env: {
          ASPNETCORE_ENVIRONMENT: {
            value: 'Development'
          }
          Identity__Url: {
            value: 'http://identity-api:8080'
          }
          ConnectionStrings__webhooksdb: {
            value: 'Host=${webhooksDb.properties.host};Port=${webhooksDb.properties.port};Database=webhooksdb;Username=myadmin;Password=${postgresPassword}'
          }
          ConnectionStrings__eventbus: {
            valueFrom: {
              secretKeyRef: {
                secretName: eventBus.properties.secrets.name
                key: 'connectionString'
              }
            }
          }
        }
        ports: {
          web: {
            containerPort: 8080
          }
        }
      }
    }
    connections: {
      webhooksdb: {
        source: webhooksDb.id
      }
      rabbitmq: {
        source: eventBus.id
      }
      identity: {
        source: identityContainer.id
      }
    }
    codeReference: 'src/Webhooks.API/Program.cs'
  }
}

resource webhooksClientContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'webhooksclient'
  properties: {
    environment: environment
    application: eshopApp.id
    containers: {
      webhooksclient: {
        image: webhooksClientImage.properties.imageReference
        env: {
          ASPNETCORE_ENVIRONMENT: {
            value: 'Development'
          }
          IdentityUrl: {
            value: 'http://identity-api:8080'
          }
        }
        ports: {
          web: {
            containerPort: 8080
          }
        }
      }
    }
    connections: {
      webhooks: {
        source: webhooksContainer.id
      }
      identity: {
        source: identityContainer.id
      }
    }
    codeReference: 'src/WebhookClient/Program.cs'
  }
}

resource webAppContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'webapp'
  properties: {
    environment: environment
    application: eshopApp.id
    containers: {
      webapp: {
        image: webAppImage.properties.imageReference
        env: {
          ASPNETCORE_ENVIRONMENT: {
            value: 'Development'
          }
          IdentityUrl: {
            value: 'http://identity-api:8080'
          }
          ConnectionStrings__eventbus: {
            valueFrom: {
              secretKeyRef: {
                secretName: eventBus.properties.secrets.name
                key: 'connectionString'
              }
            }
          }
        }
        ports: {
          web: {
            containerPort: 8080
          }
        }
      }
    }
    connections: {
      basket: {
        source: basketContainer.id
      }
      catalog: {
        source: catalogContainer.id
      }
      ordering: {
        source: orderingContainer.id
      }
      rabbitmq: {
        source: eventBus.id
      }
      identity: {
        source: identityContainer.id
      }
    }
    codeReference: 'src/WebApp/Program.cs'
  }
}
