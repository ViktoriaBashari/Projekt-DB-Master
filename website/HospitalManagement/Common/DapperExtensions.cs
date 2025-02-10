using System.Data;
using Dapper;

namespace HospitalManagement.Common;

public static class DapperExtensions
{
    public static async Task<IEnumerable<T>> QueryAsync<T>(
        this IDbConnection connection,
        Func<T> typeBuilder,
        string sql,
        object? param = null,
        IDbTransaction? transaction = null,
        int? commandTimeout = null,
        CommandType? commandType = null)
        => await SqlMapper.QueryAsync<T>(connection, sql, param, transaction, commandTimeout, commandType);
}
