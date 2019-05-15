{application,guardian_db,
             [{applications,[kernel,stdlib,elixir,logger,ecto,guardian]},
              {description,"DB tracking for token validity"},
              {modules,['Elixir.Guardian.DB','Elixir.Guardian.DB.Token',
                        'Elixir.Guardian.DB.Token.Sweeper',
                        'Elixir.Guardian.DB.Token.SweeperServer',
                        'Elixir.Mix.Tasks.Guardian.Db.Gen.Migration']},
              {registered,[]},
              {vsn,"1.1.0"}]}.
