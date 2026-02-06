using System;
using System.Collections.Generic;
using Godot;

[GlobalClass]
public partial class CurrencyInventory : Resource
{
    [Signal] public delegate void ValuesChangedEventHandler();
    [Signal] public delegate void PendingValuesChangedEventHandler();

    [Export] public Currency action_points;
    [Export] public Currency radiation;
    [Export] public Currency temperature;
    [Export] public Currency energy;
    [Export] public Currency safety_points;
    [Export] public Currency victory_points;
    [Export] public Currency difficulty;


    public void initialize()
    {
        DataBase.Initialize(this);
    }

    private string GetCurrencyPropertyName(int index)
    {
        var list = GetPropertyList();
        int currentIndex = 0;
        for (int j = 0; j < list.Count; j++)
        {
            var propertyDict = list[j];
            if (propertyDict != null && propertyDict["class_name"].ToString() == nameof(Currency))
            {
                if (currentIndex == index)
                {
                    //GD.Print($"[{j}] Name found: ", propertyDict["name"]);
                    return propertyDict["name"].ToString();
                }
                currentIndex++;
            }
        }
        throw new IndexOutOfRangeException("Индекс вне диапазона");
    }

    public override string ToString()
    {
        string result = "";
        for (int i = 0; i < length; i++)
        {
            var item = this[i];
            result += item.ToString();
            if(i < length - 1) result += "\n";
        }
        return result;
    }

    public string AsString(int size)
    {
        string result = "";
        for (int i = 0; i < length; i++)
        {
            var item = this[i];
            result += item.AsString(size);
            if(i < length - 1) result += "\n";
        }
        return result;
    }


    public Currency this[int i]
    {
        get
        {
            string propertyName = GetCurrencyPropertyName(i);
            Currency value = (Currency) Get(propertyName);
            return value;
        }
        set
        {
            string propertyName = GetCurrencyPropertyName(i);
            Set(propertyName, value);      
        }
    }

    public int length = 7;

    public Godot.Collections.Array<Currency> values()
    {
        Godot.Collections.Array<Currency> result = [];
        for (int i = 0; i < length; i++)
        {
            result.Add(this[i]);
        }
        return result;
    }

    public void set_types()
    {
        initialize();
        for (int i = 0; i < length; i++)
        {
            var item = this[i];
            var type = DataBase.CashedTypes[i];
            if (item == null)
            {
                item = Currency.Create(type);
                this[i] = item;
            }
            else
            {
                item.type = type;
            }
            item.ValueChanged += () => EmitSignal(SignalName.ValuesChanged);
        }
    }

    public Currency GetCurrency(CurrencyType.Type type)
    {
        return type switch
        {
            // Возможно ли такое?
            // CurrencyType.Type.* => *
            // (вместо * - любая строка названия поля)
            CurrencyType.Type.ActionPoints => action_points,
            CurrencyType.Type.Radiation => radiation,
            CurrencyType.Type.Temperature => temperature,
            CurrencyType.Type.Energy => energy,
            CurrencyType.Type.SafetyPoints => safety_points,
            CurrencyType.Type.VictoryPoints => victory_points,
            CurrencyType.Type.Difficulty => difficulty,
            _ => null,
        };
    }

    public Currency GetCurrencyByType(CurrencyType type)
    {
        for (int i = 0; i < length; i++)
        {
            if (this[i].type == type) return this[i];
        }
        return null;
    }

    public void ApplyAllPending()
    {
        for (int i = 0; i < length; i++)
        {
            var currency = this[i];
            currency.ApplyPending();  // Используем индексатор, добавлен null-check для безопасности
            if(currency.type == safety_points.type)
            {
                BuffPendings(currency.Value);
            }
        }
        EmitSignal(SignalName.ValuesChanged);
    }

    public void AddPending(CurrencyType.Type type, float amount)
    {
        var currency = GetCurrency(type);
        if (currency != null)
        {
            currency.pending_value += amount;
        }
        EmitSignal(SignalName.PendingValuesChanged);
    }

    public void BuffPendings(float amount)
    {
        for (int i = 0; i < length; i++)
        {
            Currency cur = this[i];
            if (cur.type.use_buff)
            {
                cur.BuffPending(amount);
            }
        }
    }
}


public static class DataBase
{
    const string PATH = "C:\\User Holder\\Dev\\Editors\\Godot\\CS Projects\\meltdown--card-game\\Resources\\Currenciese\\Types\\";

    public static List<CurrencyType> CashedTypes { get; private set; } = [];

    public static void Initialize(CurrencyInventory currency)
    {
        CashedTypes = currency.GetTypes();
    }

    public static List<CurrencyType> GetTypes(this CurrencyInventory currency)
    {
        var list = currency.GetPropertyList();
        List<CurrencyType> types = [];
        foreach (var item in list)
        {
            string className = item["class_name"].ToString();
            if (className == nameof(Currency))
            {
                string name = item["name"].ToString();
                types.Add((CurrencyType)GD.Load(PATH + name + ".tres"));
            }
        }
        return types;
    }
}