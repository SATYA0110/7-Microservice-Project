FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source
COPY payment-service.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish -c Release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/sdk:8.0
WORKDIR /app
COPY --from=build /app .
RUN addgroup -g 10007 paymentuser \
    && adduser -u 10007 -G paymentuser -D paymentuser
RUN chown -R paymentuser:paymentuser /app
USER paymentuser
EXPOSE 8080
CMD ["dotnet" , "payment-service.dll"]
