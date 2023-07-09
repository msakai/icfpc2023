module Solutions where

import qualified Data.ByteString.Lazy as B
import Data.Aeson (encode, decode)
import Text.Printf (printf)

import Answer
import Problem
import Extra
import Solver
import Happiness

saveAnswer :: (Name, SolverF)
           -> Int
           -> IO ()
saveAnswer (name, solver) probNum = do
  (ans, _problem) <- solve' name solver probNum
  let path = printf "solutions/%s_%03d.json" name probNum
  putStrLn $ "writing " ++ path --- ++ " : happiness: " ++ show (happiness problem ans)
  B.writeFile path $ encode ans

readSolutionFile :: FilePath -> IO (Maybe Answer)
readSolutionFile path = do
  inp <- B.readFile path
  return $ decode inp

readSolution :: Name -> Int -> IO (Maybe Answer)
readSolution name probNum = do
  let path = printf "solutions/%s_%03d.json" name probNum
  readSolutionFile path

calcHappiness :: FilePath -> Int -> HaStrategy -> IO Happiness
calcHappiness path probNum strategy = do
  let probMark = "problem " ++ show probNum
  problem <- maybe (fail $ "parse error: " ++ probMark) pure =<< readProblem probNum
  answer <- maybe (fail $ "parse error: " ++ probMark) pure =<< readSolutionFile path
  let extra = mkExtra problem answer
      icompat = int_compat_blocktest extra
  putStrLn $ unwords ["calulating", show strategy, show icompat, "happiness:", path]
  return $! Happiness.applyStrategy strategy extra problem answer
